#[test_only]
module 0::primitive_type {

    use aptos_std::debug::print;

    const INT:u8 =1;
    const BOO:bool =false;
    const ADDR:address =@0x1;
    // const STR:String =utf8(b"string"); //References (and reference operations) are not supported in constants



    #[test]
    fun test_pri_types(){
        let i =2;// single infer u8
        let n =257;// single infer u16
        test_infer_u8((i as u8));// reinfer both are 'u8',and occur build error "Invalid numerical literal: `257u16`"
        print(&(i+n));//

        let x =1u256 <<255;
        // let x =1 <<256; //Invalid numerical literal ,rignt operand must be u8 (0~255) and limit by source type
        print(&x);
    }

    fun test_infer_u8(_i:u8){}


}
