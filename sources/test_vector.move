module 0::test_vector{

    #[test_only]
    use std::string::utf8;
    #[test_only]
    use std::vector;
    #[test_only]
    use aptos_std::debug::print;


    const ARR:vector<u64> =vector[1,2,99999999];

    #[test]
    fun test_vector_borrow() {
        let val:&u64 = vector::borrow(&ARR,0);
        // let val:u64 = vector::borrow(&ARR,0);//specified type inacompatible
        print(val)
    }

    #[test]
    /*
    1.const values can't be modified(ref below 'const ARR')
    2.let val=... ; val=... ; ----------It's shadowing.previous one can't be accessed because compile warning below statments.
        " Unused assignment or binding for local 'val'. Consider removing, replacing with '_', or prefixing with '_' (e.g., '_val')"
    3.let val=... ; *val=...; ----------It's modifing.And if val has mutable refference ,source value will be changed.()
    */
    fun test_vector_borrow_mut() {
        let val:&mut u64 = vector::borrow_mut(&mut ARR,0);
        // let val:u64 = vector::borrow(&ARR,0);//specify type acompatible
        print(&ARR);
        val =&mut 100u64;// or { *val =100; }
        print(val);
        print(&ARR);//[1,2,99999999] const can't be modified.

        print(&utf8(b"====replace var 'arr'"));

        let arr =vector[1,2,3];
        print(&arr);
        let e=vector::borrow_mut(&mut arr,0);
        // *e =100;
        e=&mut 99u64;//new 'e' and shadowed pre 'e' ,but not modify source value.
        print(e);
        print(&arr);//[1,2,3]

        print(&utf8(b"==test modify source element in vector"));

        let ele=vector::borrow_mut(&mut arr,0);
        // *e =100;
        *ele=100;// '*' + variable name meaning "Derefference",it can modify source value.
        print(ele);
        print(&arr);//[100,2,3]
    }
}