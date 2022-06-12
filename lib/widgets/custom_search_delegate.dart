import  'package:flutter/material.dart';
import 'package:todolist/data/local_storage.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/task_models.dart';
import 'package:todolist/widgets/task_list_%C4%B1tem.dart';
class CustomSearchDelegate extends SearchDelegate{

  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});



  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: (){
        query.isEmpty? null: query ='';
      }, icon:const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        close(context, null);
      }),
      child:const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList=allTasks.where((gorev )=>gorev.name.toLowerCase().contains(query.toLowerCase())).toList();
    
    return filteredList.length>0? ListView.builder(
         itemBuilder:(context, index)  {
         var _oankiListeElemani =filteredList[index];
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
           onDismissed: (direction) async {
             filteredList.removeAt(index);
              await locator<LocalStorage>().deleteTask(task: _oankiListeElemani);
            
           },
         
           child: TaskItem(task:_oankiListeElemani )
         );
       },itemCount: filteredList.length,):
       const Center(child: Text('Aradığınızı Bulamadık'),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}
