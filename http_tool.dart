import 'package:dio/dio.dart';  // 导入第三方 dio 框架
import 'http_tool_config.dart';  // 导入常量配置文件


// 导出 net_tool 的相关依赖文件 (这样外部只需要导入 net_tool.dart文件就可以使用其他依赖模块了)
export 'http_tool_config.dart';

/*
* 1. 在dart 开发中, 文件的命名有自己的规范, 如果文件名是由多个单词组成,一般不使用驼峰, 使用_链接
*
* */
class YRHttpTool {

  // 1. 配置dio全局的 基本配置参数
  static BaseOptions baseOptions = BaseOptions(
    baseUrl: YRHttpToolConfig.baseUrl,
    connectTimeout: YRHttpToolConfig.timeOut,
//    headers:  这里我们也可以根据实际情况配置一些 公共的headers
  );

  // 2. 使用默认的 基础配置创建 dio 对象
  static final dio = Dio(baseOptions);


  // async 方法返回的是一个future
  // 这里提供了泛型, 在请求的时候就可以执行泛型 对应的实际类型
  static Future<T> request<T>(String url,
      {String method = 'get',
        Map<String, dynamic> param,
        Map<String, dynamic> headers, // http请求的header
        Interceptor interceptor}) //  拦截器, 当我们想要对请求, 响应, 错误做一些自定义的拦截就可以添加拦截器
  async {
    // 3. 创建个性化配置
    final options = Options(method: method);

    {
      // 添加全局的拦截器
      // 创建一个默认的全局拦截器
      // 在创建拦截器的时候会让你传入三个回调函数: 请求的回调函数onRequest, 响应的回调函数onResponse, 失败的回调函数onError
      Interceptor defaultInterceptor = InterceptorsWrapper(
          onRequest: (options) { // 1. 请求拦截, 如果不做处理的话, 直接返回就好, 如果需要做处理直接在这里处理即可
            print('请求拦截');
            return options;
          },
          onResponse: (response) { // 2. 响应拦截, 如果不做处理的话, 直接返回就好, 如果需要做处理直接在这里处理即可
            print('响应拦截');
            return response;
          },
          onError: (err) { // 3. 异常的拦截, 如果不做处理的话, 直接返回就好, 如果需要做处理直接在这里处理即可
            print('异常拦截');
            return err;
          }
      );

      List<Interceptor> interceptorList = [defaultInterceptor];

      // 请求单独的拦截器
      if (interceptor != null) {
        interceptorList.add(interceptor);
      }
      // 统一添加到拦截器中
      dio.interceptors.addAll(interceptorList);
    }




    // 4. 发起网络请求, 获取网络请求的响应 response
    Response response = await dio.request(url, // 到时在实际网络请求时, url 就会和 baseUrl 合并
        queryParameters: param,
        options: options); // 到时在实际网络请求时, options 就会和 baseOptions 合并

    // 5. 我们拿到response 后就能取出response 中的data 了
    return response.data;
  }

}

