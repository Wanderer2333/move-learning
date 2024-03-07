address Lesson1{
///doc comments
//regular single line comments
/*
    block comments
    */
module hello_world{
    use std::string::{String,utf8, is_empty};
    #[test_only]
    use aptos_std::debug;
    friend Lesson1::m;

    const CONST :u8 =18;


    struct Sth has drop,key,store,copy{
        //4 type key abilities
        //Any value has <move> ability(underlying capability !!!)
        //VM can infer 'copy' or 'move','=' operation generally prefer 'copy' not 'move'?
    }

    struct Person has drop {
        age: u8,//Integers: u + [num bit](8\16\32\64\128\256)   range: 0 ~ 2^(n-1)
        name: String,//need std lib to convert 'literals' -> 'bytes[]' ->> lang level string{ utf8(b"target str") }
        is_brilliant: bool,
        mail: address //fmt: @ + [numerical value]

    }

    /**
    * block doc comments (use by public\public(friend) func)
    * fun <identifier><[type_parameters: constraint],*>([identifier: type],*): <return_type> <acquires [identifier],*>
    * <function_body>
    */
    public fun test_person<>(num:u8,_x:Sth): Person {
        let p =Person{age:num, name:utf8(b"Sam Zhang"), is_brilliant:true, mail:@11};

        //integers
        let _int = 8u8;
        let _int :u8 = 8;//same named field will replace the previous one. The previous one will be shadowed.
        //boolean
        let _bool= false;
        //string
        let _str = utf8(b"literals");
        //address
        let _addr:address =@11;
        //array (may be linked list impelements)
        let _arr  = vector[1,2];

        if (is_empty(&p.name)) {
            p
        } else {
            abort 0
        }

    }


    #[test]
    fun test_helloWorld() {
        let p =Person{age:3,name : utf8(b"Simons Li"),is_brilliant: false,mail:@11};
        debug::print(&p.name)
    }
}

module m {
    use Lesson1::hello_world;
    use Lesson1::hello_world::{Sth, Person};


    fun call_person_foo(sth:Sth): Person {
        hello_world::test_person(18u8,sth)//valid calling because the 'm' is in 'hello_world' frend list.

    }
}

module n {
    fun call_person_foo(){
        // hello_world::test_person(18u8,18u8) //invaild
    }
}

}


script {

    fun test_person() {

    }
}
