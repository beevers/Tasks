import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'model/details.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final Box<Detail> requests;
  @override
  void initState() {
    super.initState();
    requests  = Hive.box('detail') ;
  }

  int id = 0;
  String? name;
  String? request;
  void _showDialog(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: const Text("Coming Soon"),
            backgroundColor: Colors.purple,
            title: const Text("Settings"),
            actions: [ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purpleAccent)
              ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Cancel",style: TextStyle(color: Colors.black),))],
          );
        }
    );
  }

  void _saveDetail(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
      requests.add(Detail(id: id, name: name.toString(), request: request.toString()));
      Navigator.pop(context);
    }

  }

  Widget getTaskBody(){
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon:const Icon(Icons.arrow_back,color: Colors.blue,)),
                  const Spacer(),
                  const Text("Add a new Thing",style: TextStyle(color: Colors.white
                      ,fontSize: 18),),
                  const Spacer(),
                  IconButton(onPressed: _showDialog, icon: const Icon(Icons.tune_outlined,color: Colors.blue,))
                ],
              ),
              const SizedBox(height: 10,),
              const Icon(Icons.panorama_fisheye_sharp,size: 70,color: Colors.deepPurple,),
              Padding(
                padding: const EdgeInsets.only(top:90,left: 20,right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Name Can't be Empty";
                          }
                          else{
                            return null;
                          }
                        },
                        onSaved: (value){
                          name = value!;
                        },
                        decoration: const InputDecoration(
                          hintText:"Name"
                      ),),
                      const SizedBox(height: 20,),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Request Can't be Empty";
                          }
                          else{
                            return null;
                          }
                        },
                        onSaved: (value){
                          request = value;
                        },
                        decoration: const InputDecoration(
                          hintText:"Request"
                      ),),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              SizedBox(
                width: 380,
                height: 50,
                child: ElevatedButton(
                    onPressed: _saveDetail,
                    child: const Text("ADD YOUR TASK")),
              ),
            ],
          ),
        ));}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurpleAccent,
      body: getTaskBody(),
    );
  }
}

