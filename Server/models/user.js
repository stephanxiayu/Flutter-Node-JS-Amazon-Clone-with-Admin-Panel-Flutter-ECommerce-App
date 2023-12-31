const mongoose =require("mongoose")

const userSchema=mongoose.Schema({
    name:{
        required:true,
        type:String,
        trim: true
    },
    email: {
        required:true,
        type:String,
        trim: true,
        validate:{
            validator:(value)=>{
                const re =  /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
             return   value.match(re)
            },
            message: "Bitte eine korrekte Email Adresse eintragen"
        },
      
    },
    password:{
        required:true,
        type:String,
        validate:{
            validator:(value)=>{

             return   value.length>6;
            },
            message: "passwort zu kurz"
        },
       
    },
    address: {
        type: String,
        default: "",
    },
    type:{
        type: String,
        default: "user"

    }

})

const User =mongoose.model("User", userSchema);

module.exports=User;