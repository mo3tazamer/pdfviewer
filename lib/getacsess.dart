import 'package:flutter/material.dart';
import 'package:pdfviewer/main.dart';
import 'package:permission_handler/permission_handler.dart';

class GetAcsess extends StatefulWidget {
   const GetAcsess({super.key});




  @override
  State<GetAcsess> createState() => _GetAcsessState();

}

class _GetAcsessState extends State<GetAcsess> {

  PermissionStatus status =PermissionStatus.denied;


  Future<void> requestPermission(Permission permission) async {
    status = await permission.request();
    if (status.isGranted) {




      print('ok');
    } else {


      print('object');
    }
  }
  @override
  void initState() {
    //requestPermission(Permission.storage);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(child:
           TextButton(child:const Text('GetAccess') ,onPressed:(){
                   if(status.isGranted){

                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const HomePage()),
                     );


                   }else{
                     requestPermission(Permission.storage);

                   }



           } ,)
      ),

    );
  }
}
