# frozen_string_literal: true

require 'pry'
# binary search tree class
class Tree
  require './node'
  def initialize(arr)
    arr = cleanse_array(arr)
    @root = build_tree(arr, 0, arr.length - 1)
  end

  def build_tree(arr, start_index, end_index)
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    root = Node.new(arr[mid_index])
    root.left = build_tree(arr, start_index, mid_index - 1)
    root.right = build_tree(arr, mid_index + 1, end_index)

    root
  end

  # iterative insert #
  def insert_iteratively(value)
    current_node = @root
    loop do
      return false if current_node.value.equal?(value) # if value already exist in tree

      # compare node value and appropriately setup left/right symbols as strings
      direction = current_node.value > value ? 'left' : 'right'
      # if the appropriate child node is empty, make new node with value in it
      return current_node.send "#{direction}=".to_sym, Node.new(value) if (current_node.send direction.to_sym).nil?

      # if the child node is not empty, set it as the current_node and keep looping
      current_node = current_node.send direction.to_sym
    end
  end

  # recursive insert #
  def insert(value, node = @root)
    return Node.new(value) if node.nil? # found the place to insert
    return node if node.value.eql?(value) # duplicate found

    direction = node.value > value ? 'left' : 'right' # setup attr accessor symbols
    node.send "#{direction}=".to_sym, insert(value, node.send(direction.to_sym)) # recursive call
    node
  end

  def delete(value, node = @root)
    # check to see if root is being deleted
    return delete_root if @root.value == value

    direction = node.value > value ? 'left' : 'right' # setup attr accessor symbols
    child = node.send(direction.to_sym)
    return nil if child.nil? # value not found in tree

    return delete_helper(node, child, direction) if child.value.eql?(value)

    delete(value, child)
  end

  # find node with value and return node
  def find(value, node = @root)
    return nil if node.nil?
    return node if node.value.eql?(value)

    node.value > value ? find(value, node.left) : find(value, node.right)
  end

  # shift and push left/right into an array queue, then process accordingly
  def level_order(queue = [@root])
    return [] if queue.empty? # base case where traversal is done

    node = queue.shift # dequeue
    queue.push(node.left) unless node.left.nil? # enqueue unless nil
    queue.push(node.right) unless node.right.nil? # enqueue unless nil
    # prepend the result to the result of recursive call
    level_order(queue).unshift(node.value)
  end

  # root second
  def inorder(node = @root, result = [])
    return if node.nil?

    inorder(node.left, result)
    result << node.value
    inorder(node.right, result)

    result
  end

  # root first
  def preorder(node = @root, result = [])
    return if node.nil?

    result << node.value
    preorder(node.left, result)
    preorder(node.right, result)

    result
  end

  # root last
  def postorder(node = @root, result = [])
    return if node.nil?

    postorder(node.left, result)
    postorder(node.right, result)
    result << node.value

    result
  end

  # if tree has just root, then height is 1
  def height(node = @root)
    return 0 if node.nil?

    1 + [height(node.left), height(node.right)].max
  end

  def depth(given_node, current_node = @root)
    return -1 if current_node.nil?
    return 1 if current_node.value.eql?(given_node.value)

    direction = current_node.value > given_node.value ? 'left' : 'right'

    1 + depth(given_node, (current_node.send direction.to_sym))
  end

  def balanced?(current_node = @root)
    balanced_helper(current_node) != -2
  end

  def rebalance
    arr = cleanse_array(level_order)
    @root = build_tree(arr, 0, arr.length - 1)
  end

  # pretty_print code from
  # https://www.theodinproject.com/courses/ruby-programming/lessons/binary-search-trees
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def cleanse_array(arr)
    arr.uniq.sort
  end

  def delete_root
    # update @root with the fake parent's right
    fake_parent = Node.new(nil, nil, @root) # to satisfy delete_helper
    delete_helper(fake_parent, fake_parent.right, 'right')
    @root = fake_parent.right
  end

  def delete_helper(parent, target, direction)
    return delete_with_no_child(parent, direction) unless target.left || target.right

    return delete_with_two_children(target) if target.left && target.right

    return delete_with_one_child(parent, target, direction) if target.left || target.right
  end

  # if target has no children, just delete its parent's reference to it
  def delete_with_no_child(parent, direction)
    parent.send "#{direction}=".to_sym, nil
  end

  # if target has one child, point the parent to the child
  def delete_with_one_child(parent, target, direction)
    # if child's left exists, assign it to parent's left/right, else assign child's right
    parent.send "#{direction}=".to_sym, (target.left || target.right)
  end

  # if target has two children, find the child just larger than target, do delete_with_one_child on it
  # and then replace the target's value with the found child's value
  def delete_with_two_children(target, direction = 'right')
    # starting from target.right, traverse left until there is a node whose left.nil?
    parent = target
    replacement = target.right
    loop do
      break if replacement.left.nil?

      direction = 'left'
      parent = replacement
      replacement = replacement.left
    end
    target.value = replacement.value
    delete_helper(parent, replacement, direction)
    # delete_with_one_child this node, then set target.value = node.value
  end

  def balanced_helper(current_node)
    return 0 if current_node.nil?

    left_child = balanced_helper(current_node.left)
    right_child = balanced_helper(current_node.right)
    return -2 if left_child == -2 || right_child == -2 || (left_child - right_child).abs > 1

    1 + (left_child > right_child ? left_child : right_child)
  end
end

driver_tree = Tree.new(Array.new(15) { rand(1..100) })
driver_tree.pretty_print
p driver_tree.balanced?
p driver_tree.level_order
p driver_tree.preorder
p driver_tree.postorder
p driver_tree.inorder
Array.new(5) { rand(101..1000) }.each { |num| driver_tree.insert(num) }
driver_tree.pretty_print
p driver_tree.balanced?
driver_tree.rebalance
driver_tree.pretty_print
p driver_tree.balanced?
p driver_tree.level_order
p driver_tree.preorder
p driver_tree.postorder
p driver_tree.inorder

#
#
#
#
# tree = Tree.new([10, 1, 1, 1, 1, 1, 1, 4, 6, 8, 11, 20, 9])
# tree.pretty_print
# puts tree
# p tree.balanced?
# tree.insert(15)
# tree.pretty_print
# puts tree
# p tree.balanced?
# tree.insert(15)
# tree.pretty_print
# puts tree
# tree.insert(7)
# tree.pretty_print
# puts tree
# tree.insert(7)
# tree.pretty_print
# p tree.level_order
# puts tree
# puts 'DELETING LEAF NODE 1'
# tree.delete(1) # deleting leaf
# tree.pretty_print
# puts 'DELETING NODE WITH ONE CHILD 20'
# tree.delete(20) # deleting node w 1 child
# tree.pretty_print
# puts 'DELETING INVALID NODE 20'
# tree.delete(20) # deleting invalid node
# tree.pretty_print
# puts 'DELETING NODE WITH TWO CHILDREN 10'
# tree.delete(10) # deleting node w 2 child
# tree.pretty_print
# puts 'DELETING ROOT NODE WITH TWO CHILDREN 8'
# tree.delete(8) # deleting root
# tree.pretty_print
# p tree.pretty_print(tree.find(11))
# p tree.pretty_print(tree.find(9))
# p tree.level_order
# p tree.inorder
# p tree.preorder
# p tree.postorder
# p tree.height
# p tree.depth(Node.new(6))
# p tree.balanced?
# tree.rebalance
# p tree
# tree.pretty_print
