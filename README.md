Author: Guo Tian, Date: Mon Feb 22, 2021

// popover controller setup refer to:
// https://slicode.com/how-to-show-popovers-in-ios-swift/

// data fetch setup refer to:
// https://www.youtube.com/watch?v=SBeizUTImoQ&t=263s

// segue setup refer to:
// https://www.codingexplorer.com/segue-uitableviewcell-taps-swift/

// UICollectionViewCompositionalLayout refer to:
// https://lickability.com/blog/getting-started-with-uicollectionviewcompositionallayout/

// filter array with string value refer to:
// https://stackoverflow.com/questions/40804458/how-to-filter-an-array-of-structs-with-value-of-other-array-in-swift

// bar button setup refer to:
// https://stackoverflow.com/questions/30022780/uibarbuttonitem-in-navigation-bar-programmatically

I noticed that the itunes api link may fail to retrieve data occasionally, 
so I added a localload function which takes .txt file downloaded from itunes api.
Uncomment locaload() function and comment fetchItems() to test locally.