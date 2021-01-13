# bst-ruby
Binary search tree implementation with ruby.

``` #build_tree(Array, start index, end index) ``` Accepts a sorted array with no duplicates, the starting index of the array, and the ending index of the array and builds a balances binary search tree. Returns the root node of the new tree.

``` #insert_iteratively(value) ``` Accepts a value and inserts it into the tree iteratively.

``` #insert(value) ``` Accepts a value and inserts it into the tree recursively.

``` #delete(value) ``` Accepts a value and deletes the corresponding node from the tree (if it exists).

``` #find(value) ``` Accepts a value and return the node object with the given value in the tree.

``` #level_order ``` Traverses the tree in level-order and returns an array of values.

``` #inorder ``` Traverses the tree in in-order and returns an array of values.

``` #preorder ``` Traverses the tree in pre-level order and returns an array of values.

``` #postorder ``` Traverses the tree in post-order and returns an array of values.

``` #height ``` Returns the height of the tree.

``` #depth(Node) ``` Accepts a node object and returns it's depth in the tree (returns -1 if it does not exist).

``` #balanced? ``` Returns true if the tree is balanced.

``` #rebalance ``` Rebalances the tree by rebuilding it and returns the root of the newly balanced tree.
