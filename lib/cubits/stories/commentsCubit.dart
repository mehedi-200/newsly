import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/data/models/comment.dart';
import 'package:newsly/data/repositories/storyRepository.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsFetchInProgress extends CommentsState {}

class CommentsFetchSuccess extends CommentsState {
  final List<Comment> comments;

  CommentsFetchSuccess(this.comments);
}

class CommentsFetchFailure extends CommentsState {
  final String errorMessage;

  CommentsFetchFailure(this.errorMessage);
}

class CommentsCubit extends Cubit<CommentsState> {
  final StoryRepository _storyRepository;

  CommentsCubit({StoryRepository? storyRepository})
      : _storyRepository = storyRepository ?? StoryRepository(),
        super(CommentsInitial());

  Future<void> getComments({required String storyId}) async {
    emit(CommentsFetchInProgress());
    try {
      final comments = await _storyRepository.getComments(storyId: storyId);
      emit(CommentsFetchSuccess(comments));
    } catch (e) {
      emit(CommentsFetchFailure(e.toString()));
    }
  }
}
