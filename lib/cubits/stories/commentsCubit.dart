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
  final String storyId;

  /// The fetch starts here rather than from a widget's build/initState, so it
  /// happens exactly once per cubit no matter how often the screen rebuilds.
  CommentsCubit({
    required this.storyId,
    StoryRepository? storyRepository,
  })  : _storyRepository = storyRepository ?? StoryRepository(),
        super(CommentsInitial()) {
    getComments();
  }

  Future<void> getComments() async {
    //A retry can be requested from a screen that is already popping.
    if (isClosed) return;

    emit(CommentsFetchInProgress());
    try {
      final comments = await _storyRepository.getComments(storyId: storyId);
      //The user can pop the screen mid-request, which closes this cubit.
      if (isClosed) return;
      emit(CommentsFetchSuccess(comments));
    } catch (e) {
      if (isClosed) return;
      emit(CommentsFetchFailure(e.toString()));
    }
  }
}
