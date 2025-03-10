import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:finalproject_pmoif20c_alif/bloc/auth/authentication_cubit.dart';
import 'package:finalproject_pmoif20c_alif/bloc/connectivity/connectivity_cubit.dart';
import 'package:finalproject_pmoif20c_alif/data/models/task_model.dart';
import 'package:finalproject_pmoif20c_alif/data/repositories/firestore_crud.dart';
import 'package:finalproject_pmoif20c_alif/presentation/widgets/mybutton.dart';
import 'package:finalproject_pmoif20c_alif/presentation/widgets/myindicator.dart';
import 'package:finalproject_pmoif20c_alif/presentation/widgets/mysnackbar.dart';
import 'package:finalproject_pmoif20c_alif/presentation/widgets/mytextfield.dart';
import 'package:finalproject_pmoif20c_alif/presentation/widgets/task_container.dart';
import 'package:finalproject_pmoif20c_alif/shared/constants/assets_path.dart';
import 'package:finalproject_pmoif20c_alif/shared/constants/consts_variables.dart';
import 'package:finalproject_pmoif20c_alif/shared/constants/strings.dart';
import 'package:finalproject_pmoif20c_alif/shared/services/notification_service.dart';
import 'package:finalproject_pmoif20c_alif/shared/styles/colors.dart';
import 'package:finalproject_pmoif20c_alif/presentation/screens/addtask_screen.dart';
import 'package:finalproject_pmoif20c_alif/services/shared_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var currentdate = DateTime.now();

  //final TextEditingController _usercontroller = TextEditingController(
    //  text: FirebaseAuth.instance.currentUser!.displayName);

  @override
  void initState() {
    super.initState();

    NotificationsHandler.requestpermission(context);
  }

  @override
  void dispose() {
    super.dispose();

   // _usercontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authenticationCubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    //final user = FirebaseAuth.instance.currentUser;
    //String username = user!.isAnonymous ? 'Anonymous' : 'User';

    return Scaffold(
      //resizeToAvoidBottomInset: false,
        body: MultiBlocListener(
            listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
            if (state is ConnectivityOnlineState) {
              MySnackBar.error(
                  message: 'You Are Online Now ',
                  color: Colors.green,
                  context: context);
            } else {
              MySnackBar.error(
                  message: 'Please Check Your Internet Connection',
                  color: Colors.red,
                  context: context);
            }
          }),
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              if (state is UnAuthenticationState) {
                Navigator.pushNamedAndRemoveUntil(
                    context, welcomepage, (route) => false);
              }
            },
          )
        ],
            child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationLoadingState) {
                  return const MyCircularIndicator();
                }

                return SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 3.w,
                          ),
                         
                         Expanded(
                           child: Row(
                             children: [
                               InkWell(
                                  onTap: () {
                                    _showBottomSheet(context, authenticationCubit);
                                  },
                                  child: Icon(
                                    Icons.menu_sharp,
                                    size: 25.sp,
                                    color: Appcolors.black,
                                  ),
                                ),
                             ],
                           ),
                            )
                           
                          
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('MMMM, dd').format(currentdate),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 17.sp),
                          ),
                          const Spacer(),
                          MyButton(
                            color: Colors.red,
                            width: 40.w,
                            title: '+ Add Task',
                            func: () {
                              Navigator.pushNamed(
                                context,
                                addtaskpage,
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      _buildDatePicker(context, connectivitycubit),
                      SizedBox(
                        height: 4.h,
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FireStoreCrud().getTasks(
                          mydate: DateFormat('yyyy-MM-dd').format(currentdate),
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TaskModel>> snapshot) {
                          if (snapshot.hasError) {
                            return _nodatawidget();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const MyCircularIndicator();
                          }

                          return snapshot.data!.isNotEmpty
                              ? Expanded(
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var task = snapshot.data![index];
                                      Widget _taskcontainer = TaskContainer(
                                        id: task.id,
                                        color: colors[task.colorindex],
                                        title: task.title,
                                        starttime: task.starttime,
                                        endtime: task.endtime,
                                        note: task.note,
                                        lokasi: task.lokasi,
                                      );
                                      return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, addtaskpage,
                                                arguments: task);
                                          },
                                          child: index % 2 == 0
                                              ? BounceInLeft(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  child: _taskcontainer)
                                              : BounceInRight(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  child: _taskcontainer));
                                    },
                                  ),
                              )
                              : _nodatawidget();
                        },
                      )),
                    ],
                  ),
                ));
              },
            )));
  }

  Future<dynamic> _showBottomSheet(
      BuildContext context, AuthenticationCubit authenticationCubit) {
    //var user = FirebaseAuth.instance.currentUser!.isAnonymous;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: ((context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //(user)
                    //    ? Container()
                        Wrap(
                            children: List<Widget>.generate(
                              4,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: InkWell(
                                  onTap: () async {
                                    _updatelogo(index, setModalState);

                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setInt('plogo', index);
                                  },
                                  child: Container(
                                      height: 8.h,
                                      width: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  profileimages[index]),
                                              fit: BoxFit.cover)),
                                      child: profileimagesindex == index
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.red,
                                              size: 8.h,
                                            )
                                          : null),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 3.h,
                    ),
                   
                    SizedBox(
                      height: 3.h,
                    ),
                    MyButton(
                      color: Colors.red,
                      width: 80.w,
                      title: "Log Out",
                      func: () {
                        //authenticationCubit.signout();
                        SharedService.logout(context);
                      },
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void _updatelogo(int index, void Function(void Function()) setstate) {
    setstate(() {
      profileimagesindex = index;
    });
    setState(() {
      profileimagesindex = index;
    });
  }

  Widget _nodatawidget() {
    return Center(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              MyAssets.clipboard,
              height: 30.h,
            ),
            SizedBox(height: 3.h),
            Text(
              'There Is No Tasks',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildDatePicker(
      BuildContext context, ConnectivityCubit connectivityCubit) {
    return SizedBox(
      height: 15.h,
      child: DatePicker(
        DateTime.now(),
        width: 20.w,
        initialSelectedDate: DateTime.now(),
        dateTextStyle:
            Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18.sp),
        dayTextStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 10.sp, color: Appcolors.black),
        monthTextStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 10.sp, color: Appcolors.black),
        selectionColor: Colors.red,
        onDateChange: (DateTime newdate) {
          setState(() {
            currentdate = newdate;
          });
          if (connectivityCubit.state is ConnectivityOnlineState) {
          } else {
            MySnackBar.error(
                message: 'Please Check Your Internet Conection',
                color: Colors.red,
                context: context);
          }
        },
      ),
    );
  }
}
