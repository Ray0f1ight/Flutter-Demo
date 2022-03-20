import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String uri = "https://api.stackexchange.com/2.2/users";

class HttpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HttpPage();
  }
}

class _HttpPage extends State<HttpPage> {
  ResponseBean responseBean = ResponseBean([]);

  _HttpPage() {
    getResponse();
  }

  @override
  Widget build(BuildContext context) {
    print("页面刷新");
    return Scaffold(
        appBar: AppBar(
          title: Text('请求网络数据'),
        ),
        body:
            // Container(
            //   width: 300,
            //   height: 500,
            //   color: Colors.blue,
            //   child: Column(
            //     children: [
            //       ListView.builder(itemBuilder: (context,index){
            //         BeanForHttp item = responseBean.items[index];
            //         return ListTile(title: Text(item.display_name??""),
            //           leading: Image.network(item.profile_image??""),
            //         );
            //       },
            //         itemCount: responseBean.items.length,)
            //     ],
            //     mainAxisAlignment: MainAxisAlignment.center,),
            // ),
            ListView.builder(itemBuilder: (context, index) {
          BeanForHttp item = responseBean.items[index];
          return ListTile(
            title: Text(item.display_name ?? ""),
            leading:
            Container(
              width: 30,height: 30,
              child: Image.network(item.profile_image ?? "",
              loadingBuilder: (context,child,loadingProgress){
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress?.expectedTotalBytes != null
                        ? ((loadingProgress?.cumulativeBytesLoaded??0) / (loadingProgress?.expectedTotalBytes??1))
                        : null,
                  ),
                );
              },

              ),
            )
            ,
          );
        },
        itemCount: responseBean.items.length
        ));
  }

  void getResponse() async {
    Response response = await DioInstance.getInstance().get(uri,
        queryParameters: {
          "page": "1",
          "pagesize": "6",
          "site": "stackoverflow"
        });
    setState(() {
      responseBean = ResponseBean.fromJson(response.data);
    });
  }
}

class DioInstance {
  static Dio? dio = null;

  static Dio getInstance() {
    if (dio == null) {
      dio = Dio()..interceptors.add(ErrorIntercept());
    }
    return dio!;
  }
}

class ErrorIntercept extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("网络请求成功：${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("网络请求错误：$err");
    super.onError(err, handler);
  }
}

class ResponseBean {
  List<BeanForHttp> items;

  ResponseBean(this.items);

  factory ResponseBean.fromJson(Map<String, dynamic> json) {
    final list = json["items"] as List;
    List<BeanForHttp> data =
        list.map((value) => BeanForHttp.fromJson(value)).toList();
    return ResponseBean(data);
  }

  @override
  String toString() {
    var res = json.encode(this);
    return res;
  }
}

class BeanForHttp {
  String? profile_image;
  String? display_name;

  BeanForHttp(this.profile_image, this.display_name);

  factory BeanForHttp.fromJson(Map<String, dynamic> json) {
    return BeanForHttp(json["profile_image"], json["display_name"]);
  }
}
