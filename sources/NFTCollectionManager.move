module pavani_addr::NFTCollectionManager {
    use aptos_framework::signer;
    use std::string::{Self, String};
    use std::vector;

    /// Struct representing an NFT collection with series and editions
    struct Collection has store, key {
        name: String,
        total_series: u64,
        total_editions: u64,
        series_list: vector<Series>,
    }

    /// Struct representing a series within a collection
    struct Series has store, drop, copy {
        id: u64,
        name: String,
        edition_count: u64,
        max_editions: u64,
    }

    /// Function to create a new NFT collection
    public fun create_collection(
        creator: &signer, 
        collection_name: vector<u8>
    ) {
        let name = string::utf8(collection_name);
        let collection = Collection {
            name,
            total_series: 0,
            total_editions: 0,
            series_list: vector::empty<Series>(),
        };
        move_to(creator, collection);
    }

    /// Function to add a new series to an existing collection
    public fun add_series(
        owner: &signer,
        series_name: vector<u8>,
        max_editions: u64
    ) acquires Collection {
        let owner_addr = signer::address_of(owner);
        let collection = borrow_global_mut<Collection>(owner_addr);
        
        let series_id = collection.total_series + 1;
        let name = string::utf8(series_name);
        
        let new_series = Series {
            id: series_id,
            name,
            edition_count: 0,
            max_editions,
        };
        
        vector::push_back(&mut collection.series_list, new_series);
        collection.total_series = collection.total_series + 1;
    }
}