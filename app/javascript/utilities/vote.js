$(document).on('turbolinks:load', function(){
    $('.vote').on('ajax:success', function(e) {
        console.log('111', )
        var detail = e.detail[0] || false;
        var rating = detail.rating;
        var resourceName =  detail.resource_name;
        var resourceId = detail.resource_id;

        console.log('resourceName', resourceName)
        console.log('resourceId', resourceId)

        $('#rating-' + resourceName + '-' + resourceId).html(rating)
    })
});