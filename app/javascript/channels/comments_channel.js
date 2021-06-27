import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
  connected() {
    return this.perform('stream_from');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var type = data.comment.commentable_type.toLowerCase();
    var id = data.comment.commentable_id;

    if (type == 'question') {
      $('.comments-question').append(data['partial']);
    } else {
      $(`.comments-answer-${id}`).append(data['partial']);
    }
  }
});
