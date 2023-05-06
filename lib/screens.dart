import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/model/details.dart';
import 'package:todo/state.dart';
import 'package:todo/task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Box<Detail> todo;

  @override
  void initState() {
    super.initState();
    todo  = Hive.box('detail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  const Drawer(
        child: Center(
          child: Text("Coming Soon",style: TextStyle(fontSize:23),),
        ),
      ),
      key: _scaffoldKey,
      body: ValueListenableBuilder(
          valueListenable: todo.listenable(),
          builder: (BuildContext context, Box<Detail> value, Widget? child) { return getBody(); },
           ),
      floatingActionButton: floatButton(),
    );

  }

  Padding floatButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20,right: 10),
      child: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskScreen()));
        },
        child: const Icon(Icons.add,size: 35,),
      ),
    );
  }

  Widget getBody() {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yMd').format(dateTime);
    String time = formattedDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/wall.jpg"),
              fit: BoxFit.cover
            )
          ),
          width: double.infinity,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(top: 25,left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  icon:const Icon(color:Colors.white,Icons.segment),),
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text("Your",style: TextStyle(fontSize: 40,color: Colors.white),),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text("Things",style: TextStyle(fontSize: 40,color: Colors.white),),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(time.toString(),style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15,),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text("INBOX"),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: todo.length,
              itemBuilder: (context, index){
                final eachRequest = todo.getAt(index) as Detail;
                final ticks = context.watch<AppProvider>().addedList;
                bool isSaved = ticks.contains(eachRequest);
            return Column(
              children:  [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('images/person-placeholder.png'),
                  ),
                   title: Text(eachRequest.request.toString()),
                  subtitle: Text(eachRequest.name.toString(),
                    style: const TextStyle(color: Colors.grey) ,),
                   trailing: IconButton(
                     onPressed: (){
                       setState(() {
                         if(isSaved){
                           context.read<AppProvider>().removeTodo(eachRequest);
                         }
                         else{
                           context.read<AppProvider>().addTodo(eachRequest);
                         todo.deleteAt(index);
                         }
                       });

                     },
                     icon: const Icon(Icons.delete),
                   )
                 ),
                const Padding(
                  padding: EdgeInsets.only(left: 8,right: 8),
                  child: Divider(thickness: 1,),
                )
              ],
            );
          }),
        ),
        todo.length == 0 ? Container() : Card(
          color: Colors.grey[300],
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text("Request",style:TextStyle(
                  fontSize: 25,
                  color: Colors.grey
                ),),
                Container(
                  width: 40,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                   shape: BoxShape.circle
                  ),
                  child: Center(child: Text("${todo.length}",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white),)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
