
import 'package:flutter/material.dart';
import 'package:todolist/data/local_storage.dart';
import 'package:todolist/main.dart';

import 'package:todolist/models/task_models.dart';
import 'package:intl/intl.dart';
class TaskItem extends StatefulWidget {
   Task task;
   TaskItem({Key? key,required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage=locator<LocalStorage>();
    
    
    
    
  }
  @override
  Widget build(BuildContext context) {
    _taskNameController.text=widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8) ,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(1),
            blurRadius: 10
          )
        ]
      ),
      child: ListTile(
        
        leading: GestureDetector(
          onTap: () {
        widget.task.isCompleted=! widget.task.isCompleted;
        _localStorage.updateTask(task: widget.task);
        setState(() {
          
        });
           },
          child: Container(
            child:const Icon(
              Icons.check),
          decoration: BoxDecoration(

            color: widget.task.isCompleted?Colors.green:Colors.white,
            border: Border.all(color: Colors.grey,width: 0.8),
            shape: BoxShape.circle),

           ),
         ),
          title:widget.task.isCompleted ? 
          Text(
            widget.task.name,
            style:const TextStyle(
              decoration:TextDecoration.lineThrough,
          color: Colors.grey),
          ):
            
         TextField(
            controller: _taskNameController,
            minLines: 1,
            maxLines: null,
            textInputAction: TextInputAction.done,
            decoration:const InputDecoration(border: InputBorder.none),
            onSubmitted: (yeniDeger){
              if(yeniDeger.length>3){
                widget.task.name=yeniDeger;
                _localStorage.updateTask(task: widget.task);

              }
              
            }
            

          ),
          trailing: Text(
            DateFormat('hh:mm a').format(widget.task.createdAt),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
       
       ), 
      );
  }
}