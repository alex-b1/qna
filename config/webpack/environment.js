const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jquery: 'jquery',
        jQuery: 'jquery',
    })
)

environment.loaders.append('hbs', {
    test: /\.hbs$/,
    loader: 'handlebars-loader'
})

module.exports = environment
