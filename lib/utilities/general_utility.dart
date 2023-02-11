import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../base_classes/base_text.dart';
import '../constants/color_constant.dart';
import '../constants/string_constant.dart';
import '../utilities/custom_controls/np_alert_dialog.dart';
import '../utilities/custom_controls/np_loader_dialog.dart';
import '../enums/font_enum.dart';
import 'managers/np_image_picker.dart';

class GeneralUtility {

  static GeneralUtility? _instance;
  GeneralUtility._internal() {
    _instance = this;
  }

  static GeneralUtility get shared => _instance ?? GeneralUtility._internal();

}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

enum AlertAction { ok, cancel, yes, no }
extension ExtAlertAction on AlertAction {
  String get displayText {
    switch(this) {
      case AlertAction.ok: return "OK";
      case AlertAction.cancel: return "CANCEL";
      case AlertAction.yes: return "YES";
      case AlertAction.no: return "NO";
    }
  }
  TextStyle get textStyle {
    switch(this) {
      case AlertAction.no:
        return GeneralUtility.shared.getTextStyle(color: Colors.red);
      default:
        return GeneralUtility.shared.getTextStyle(color: Colors.blue);
    }
  }
}


extension ExtGeneralUtility1 on GeneralUtility {

  getTextStyle({MyFont myFont = MyFont.rRegular, Color? color, Color? bgColor, double fontSize = 15}) {
    return TextStyle(
        fontFamily: myFont.family,
        fontWeight: myFont.weight,
        color: color,
        backgroundColor: bgColor,
        fontSize: fontSize
    );
  }

  push(BuildContext context, Widget page, {int delay = 1, void Function()? onPop}) {
    Future.delayed(Duration(microseconds: delay), (){
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((value) {
        // print("Popped");
        if(onPop != null) {
          onPop();
        }
      });
    });
  }

  pushAndRemove(BuildContext context, Widget page, {int delay = 1}) {
    Future.delayed(Duration(microseconds: delay), (){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), (_) => false);
    });
  }

  pop(BuildContext context, {int delay = 1}) {
    Future.delayed(Duration(microseconds: delay), (){
      Navigator.of(context).pop();
    });
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Size getScreenSize(BuildContext buildContext) {
    return MediaQuery.of(buildContext).size;
  }

  getNoDataView({String? message}) {
    return Center(
      child:  BaseText(text: message ?? StringConst.noDataFound, color: ColorConst.black, fontSize: 20,),
    );
  }

  Image getAssetImage({String? name, double? height, double? width, BoxFit? fit, String? ext, Color? color}){
    if (height != null || width != null) {
      return Image.asset("assets/images/${name ?? ""}.${ext ?? "png"}", fit: fit ?? BoxFit.none, color: color, height: height, width: width,);
    }
    return Image.asset("assets/images/${name ?? ""}.${ext ?? "png"}", fit: fit ?? BoxFit.fill, color: color,);
  }

  // Image getNetworkImage({String? url, double? height, double? width, BoxFit? fit, String? ext, Color? color}){
  //   if (url?.isSpaceEmpty() ?? false) {
  //     return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
  //   }
  //   if (height != null || width != null) {
  //     return Image.network(url ?? "", fit: fit ?? BoxFit.none, color: color, height: height, width: width, errorBuilder: (context,object,_) {
  //       return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
  //     },);
  //   }
  //   return Image.network(url ?? "", fit: fit ?? BoxFit.fill, color: color, height: height, width: width, errorBuilder: (context,object,_) {
  //     return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
  //   },);
  // }
  //
  // Image getBase64Image({String? base64String, double? height, double? width, BoxFit? fit, String? ext, Color? color}) {
  //   if(base64String?.isSpaceEmpty() == true) {
  //     return getAssetImage(name: ImageConst.icUserDoctorPlaceholder, ext: "png", height: height, width: width, fit: fit, color: color);
  //   }
  //   return Image.memory(base64Decode(base64String ?? ""), fit: fit, height: height, width: width, color: color);
  // }

}

extension ExtGeneralUtility2 on GeneralUtility {

  showProcessing({String? message, bool isFromInitState = true}) {
    if (navKey.currentContext == null) {
      return;
    }
    if (isFromInitState) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (BuildContext buildContext) {
          return NPLoaderDialog(message: message);
        });
      });
    } else {
      showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (BuildContext buildContext) {
        return NPLoaderDialog(message: message);
      });
    }
  }

  hideProcessing({bool isFromInitState = true}) {
    if (navKey.currentContext == null) {
      return;
    }
    if (isFromInitState) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(navKey.currentContext!).pop();
      });
    } else {
      Navigator.of(navKey.currentContext!).pop();
    }
  }

  showSnackBar(String message) {
    if (navKey.currentContext == null) {
      return;
    }
    ScaffoldMessenger.of(navKey.currentContext!).removeCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(snackBar);
  }

  showAlert({String? title, String? message, List<AlertAction>? listActions, void Function(AlertAction)? completion}) {
    if (navKey.currentContext == null) {
      return;
    }
    List<AlertAction> actions = listActions ?? [];
    if(actions.isEmpty) {
      actions = [AlertAction.ok];
    }
    Future.delayed(const Duration(microseconds: 1), (){
      showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (BuildContext buildContext) {
        return NPAlertDialog(title: title, message: message, listActions: actions, completion: (alertAction){
          Navigator.of(buildContext).pop();
          if(completion != null) {
            completion(alertAction);
          }
        });
      });
    });
  }

  showDatePicker({DateTime? initialSelectedDate, required void Function(DateTime? selectedDate) completion}){
    if (navKey.currentContext == null) {
      return;
    }
    showDialog(context: navKey.currentContext!, barrierDismissible: false, builder: (dialogContext){
      return Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: SfDateRangePicker(
                selectionColor: ColorConst.primary,
                todayHighlightColor: ColorConst.primary,
                initialSelectedDate: initialSelectedDate,
                showNavigationArrow: true,
                showTodayButton: true,
                showActionButtons: true,
                onCancel: (){
                  Navigator.of(dialogContext).pop();
                },
                onSubmit: (obj){
                  if (obj != null) {
                    DateTime? selectedDate = obj as DateTime?;
                    Navigator.of(dialogContext).pop();
                    completion(selectedDate);
                  } else {
                    showSnackBar("Please select any date.");
                  }
                },
                selectionMode: DateRangePickerSelectionMode.single,
              ),
            ),
          ],
        ),
      );
    });
  }

  showImagePicker({bool withRemoveOption = true, required void Function(ImagePickType, XFile?)? imagePickType}) {
    if (navKey.currentContext == null){
      return;
    }
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            )
        ),
        backgroundColor: Colors.white,
        context: navKey.currentContext!,
        builder: (context) {
          return NPImagePicker(completion: imagePickType);
        });
  }

}


extension ExtGeneralUtility3 on GeneralUtility {

  Future<XFile?> imageFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    return image;
  }

  Future<XFile?> imageFromGallery() async {
    XFile? image = await  ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    return image;
  }

}