import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../data/datasources/post_local_datasource.dart';
import '../../data/datasources/post_remote_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../presentation/stores/auth_store.dart';
import '../../presentation/stores/post_store.dart';
import '../services/back4app_setup_service.dart';
import '../utils/image_picker_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final Dio _dio;
  late final PostRemoteDatasource _postRemoteDatasource;
  late final PostLocalDatasource _postLocalDatasource;
  late final UserRemoteDatasource _userRemoteDatasource;
  late final PostRepository _postRepository;
  late final UserRepository _userRepository;
  late final AuthStore _authStore;
  late final PostStore _postStore;
  late final ImagePickerService _imagePickerService;
  late final Back4AppSetupService _back4AppSetupService;

  void setup() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _postRemoteDatasource = PostRemoteDatasourceImpl(_dio);
    _postLocalDatasource = PostLocalDatasourceImpl();
    _userRemoteDatasource = UserRemoteDatasourceImpl(_dio);

    _postRepository = PostRepositoryImpl(
      remoteDatasource: _postRemoteDatasource,
      localDatasource: _postLocalDatasource,
    );
    _userRepository = UserRepositoryImpl(
      remoteDatasource: _userRemoteDatasource,
    );

    _authStore = AuthStore(_userRepository);
    _postStore = PostStore(_postRepository);

    _imagePickerService = ImagePickerService();
    _back4AppSetupService = Back4AppSetupService(_dio);
  }

  Dio get dio => _dio;
  PostRepository get postRepository => _postRepository;
  UserRepository get userRepository => _userRepository;
  AuthStore get authStore => _authStore;
  PostStore get postStore => _postStore;
  ImagePickerService get imagePickerService => _imagePickerService;
  Back4AppSetupService get back4AppSetupService => _back4AppSetupService;
}

