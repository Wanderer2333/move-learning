address MyAddr{
///doc comments
//regular single line comments
/*
    block comments
    */
module hello_world{
    use std::string::{String,utf8, is_empty, append, append_utf8, bytes};
    use aptos_std::debug::print;
    use aptos_std::string_utils;
    #[test_only]
    use aptos_std::debug;

    friend MyAddr::m;

    const CONST :u8 =18;

    // All structs are only usable in internal of module.
    struct Sth has drop,key,store,copy{
        //4 type key abilities
        //Any value has 'move' ability(~~ underlying capability ~~)
        //VM can infer 'copy' or 'move','=' operation generally prefer 'copy' not 'move'?

        //- 'drop' for destory resouce through VM

        /*The func add 'acquires' reserved word for that some special resources could be accessed from global storage.*/
        //- 'key' for global storage index.
        //- 'store' for global storage.

        //- 'copy' for copy resource rather than modify soure.

        //!!!!! Non struct resources default have 'store','drop' and 'copy' abilities. !!!!!
    }

    struct Person has drop,copy {
        age: u8,//Integers: u + [num bit](8\16\32\64\128\256)   range: 0 ~ 2^(n-1)
        is_brilliant: bool,
        mail: address,//fmt: @ + [numerical value]

        name: String,//need std lib to convert 'literals' -> 'bytes[]' ->> lang level string{ utf8(b"target str") }
    }

    /**
    * block doc comments (use by public\public(friend) func)
    * fun <identifier><[type_parameters: constraint],*>([identifier: type],*): <return_type> <acquires [identifier],*>
    * <function_body>
    *
    * 4 func modifiers
    * - 'pulibic' for any module of any address access this func.
    * - 'pulibic(friend)' for one module from its friend list access this func.
    * - nil modifier(or default) only for one module access this func internally(private for module).
    *
    * - 'entry' for some scripts off chain access this func extraly,and this func could not have return type!
    * https://move-dao.github.io/move-book-zh/functions.html#entry-%E4%BF%AE%E9%A5%B0%E7%AC%A6-entry-modifier
    */
    public(friend) fun test_person<>(num:u8,_x:Sth): Person {
        let p =Person{age:num, name:utf8(b"Sam Zhang"), is_brilliant:true, mail:@11};

        //integers
        let _int = 8u8;
        let _int :u8 = 8;//same named field will replace the previous one. The previous one will be shadowed.
        //boolean
        let _bool= false;
        //string
        let _str = utf8(b"literals");
        // let str =String{};//invalid for a struct of external module.
        //address
        let _addr:address =@11;
        //array (may be linked list impelements)
        let _arr  = vector[1,2];

        //if u want modify the 'p' struct source value
        let p2 = copy p;
        let Person{age,name,is_brilliant,mail} =&mut p;
        print(&p.name);
        append_utf8(&mut p.name,b" _append str");
        print(&p.name);


        if (!is_empty(&p.name)) {
            p
        } else {
            Person{age:0,name:utf8(b""),mail:@007,is_brilliant:false}
        }

    }


    #[test]
    fun test_helloWorld() {
        let p =Person{age:3,name : utf8(b"Simons Li"),is_brilliant: false,mail:@11};
        debug::print(&p.name);

        let s =Sth{};

        test_person( 0, s);
    }
}

// #[test_only]
module m {
    use MyAddr::hello_world;
    use MyAddr::hello_world::{Sth, Person};//only to decleration,but forbid struct obj be a instance

    #[test_only]
    fun call_person_foo(sth: Sth): Person {//struct is not supported to inject a func!!!
        hello_world::test_person(18u8,sth)//valid calling because the 'm' is in 'hello_world' frend list.

    }
}

module n {
    use std::signer;
    use std::string;
    #[test_only]
    use aptos_std::debug::print;

    #[test(account=@0x11)] //#[test] and #[test_only] are conflicts
    fun call_person_foo(account: &signer){
        // let sth =Sth{}; //struct only could be created instance in internal of module.
        // hello_world::test_person(18u8,sth) //invaild calling for non friend module
        print(account)
    }
}

}


script {

    fun test_person() {

    }
}
