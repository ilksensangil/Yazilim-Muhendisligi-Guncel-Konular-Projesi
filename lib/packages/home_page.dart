
import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/data/local_storage.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/task_models.dart';
import 'package:todolist/widgets/custom_search_delegate.dart';
import 'package:todolist/widgets/task_list_%C4%B1tem.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(
    
  );
}

class _HomePageState extends State<HomePage> {
  late List<Task>_allTasks;
  late LocalStorage _localStorage;
  @override
 void initState()   {
   
    super.initState();
    _localStorage=locator<LocalStorage>();
    _allTasks=<Task>[];
    _getAllTaskFromDb();

    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade300,
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.yellow.shade300,
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: Text('Bugün Neler Yapacaksın?',
           style: TextStyle(color: Colors.black),
           ),
          ),
        centerTitle: false,
        actions:[
          IconButton (onPressed:  () {
            _showSearchPage();
          },
           icon:const Icon(Icons.search ),

           ),
           IconButton (onPressed:  () {
             _showAddTaskBottomSheet();
           },
           icon:const Icon(Icons.add ),

           ),
         ],
       ),
       body:_allTasks.isNotEmpty? 
       ListView.builder(
         itemBuilder:(context, index)  {
         var _oankiListeElemani =_allTasks[index];
         return Dismissible(
           background: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: const [
               Icon(Icons.delete,
               color: Colors.grey,
               ),
               SizedBox(
                 width: 8
                 ,
                 ),
               Text ('Bu Görev Silindi')
               
             ],
           ),
           key: Key(_oankiListeElemani.id ),
           onDismissed: (direction) {
             _allTasks.removeAt(index);
              _localStorage.deleteTask(task: _oankiListeElemani);
             setState(() {
               
             });
           },
         
           child: Column(
             children: [
               TaskItem(task:_oankiListeElemani ),
               Divider()
             ],
           )
         );
       },itemCount: _allTasks.length,):
       Center (child: Lottie.asset("assets/notyok.json")),
     );
   }

  void _showAddTaskBottomSheet( ) {
    showModalBottomSheet(context: context, builder:(context){
      return Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          title: TextField(
            autofocus: true,
            style:const TextStyle(fontSize: 20),
            decoration:const InputDecoration(
            hintText: 'Görev Nedir?',
            border: InputBorder.none),

            onSubmitted:(value){
              Navigator.of(context).pop();
              if (value.length>3){
              DatePicker.showTimePicker(
                
                
                context,
                locale: LocaleType.tr,
                showSecondsColumn:false ,onConfirm:(time)
              
              async {
                var yeniEklenecekGorev=
                Task.create(name: value, createdAt: time);
                _allTasks.insert(0,yeniEklenecekGorev);
                await _localStorage.addTask(task: yeniEklenecekGorev);
                setState(() {
                  
                });
              } );
              }
             },
            ),
          ),
        );
      },
    );
  }

   _getAllTaskFromDb() async {
    _allTasks= await _localStorage.getAllTask();
    setState(() {
      
    });
  }

  void _showSearchPage() async {
    await showSearch(context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTaskFromDb();
  }
}