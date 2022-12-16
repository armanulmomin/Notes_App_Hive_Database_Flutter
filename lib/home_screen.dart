import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_hive_database_flutter/boxes/boxes.dart';
import 'package:notes_app_hive_database_flutter/models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hive Database"),),
    body: ValueListenableBuilder<Box<NotesModel>>(
      valueListenable:Boxes.getData().listenable() ,
      builder: (context, box,_){
        var data = box.values.toList().cast<NotesModel>();
        return ListView.builder(
            itemCount: box.length,
            itemBuilder: (contex,index)
        {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(data[index].title.toString(),),
            Spacer(),
            InkWell(
                onTap: (){
                  _editDialog(data[index], data[index].title.toString(), data[index].description.toString());
                },
                child: Icon(Icons.edit)),
            SizedBox(width: 20,),
            InkWell(
                onTap: (){
                  delete(data[index]);
                  
                  
                },
                child: Icon(Icons.delete)),




                    ],


                  ),
          Text(data[index].description.toString())

                ],
              ),
            ),
          );
        }
        );

      },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showDialog();
        },
        child: Icon(Icons.add),
      ),
    );

  }
  void delete(NotesModel notesModel) async
  {
    await notesModel.delete();

  }

  Future<void> _editDialog(NotesModel notesModel,String title, String description) async{

    titleController.text = title;
    desController.text = description;
    return showDialog(context: context, builder: (context){
      return AlertDialog(

        title: Text('Edit Notes'),
        content: SingleChildScrollView(
          child: ListBody(

            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(

                    )
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: desController,
                decoration: InputDecoration(
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(

                    )
                ),
              )
            ],
          ),
        ),
        /*
        content: SingleChildScrollView(
          child: ListView(

            children: [
              TextFormField()
            ],
          ),
        ),

         */


        actions: [
          TextButton (onPressed: () async {
            notesModel.title = titleController.text.toString();
            notesModel.description = desController.text.toString();
            await notesModel.save();
            desController.clear();
            titleController.clear();

            Navigator.pop(context);
          }, child: Text('Edit')),

          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel  ')),

        ],
      );
    });
  }
  Future<void> _showDialog() async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(

        title: Text('Add Notes'),
        content: SingleChildScrollView(
          child: ListBody(

              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(

                    )
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: desController,
                  decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(

                      )
                  ),
                )
              ],
          ),
        ),
        /*
        content: SingleChildScrollView(
          child: ListView(

            children: [
              TextFormField()
            ],
          ),
        ),

         */


        actions: [
          TextButton(onPressed: (){
            final data = NotesModel(title: titleController.text, description: desController.text);
            final box = Boxes.getData();
            box.add(data);
            data.save();
            titleController.clear();
            desController.clear();
            Navigator.pop(context);
          }, child: Text('Add')),

          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel  ')),

        ],
      );
    });
  }
}
