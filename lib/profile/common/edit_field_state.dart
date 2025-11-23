part of 'edit_field_cubit.dart';

abstract class EditFieldState {}

class EditFieldInitial extends EditFieldState {}

class EditFieldLoading extends EditFieldState {}

class EditFieldSuccess extends EditFieldState {}

class EditFieldError extends EditFieldState {
  final String message;
  EditFieldError(this.message);
}
