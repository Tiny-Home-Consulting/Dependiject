//
//  index.js
//  Dependiject
//
//  Created by William Baker on 04/27/22.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//  

const path = require('path');
const hapi = require('@hapi/hapi');
const inert = require('@hapi/inert');

const basePath = path.join(
    __dirname,
    '../iOS 13 Example/build/Release-iphoneos/Dependiject/Dependiject.doccarchive'
);

(async () => {
    const server = hapi.server({
        routes: {
            files: {
                relativeTo: basePath
            }
        },
        host: 'localhost',
        port: process.env.DOC_PORT || 0
    });

    await server.register(inert);

    server.route([
        {
            method: 'GET',
            path: '/{param*}',
            handler: {
                directory: {
                    path: '.'
                }
            }
        },
        {
            method: 'GET',
            path: '/',
            handler(req, res) {
                return res.redirect('/documentation/dependiject');
            }
        },
        {
            method: 'GET',
            path: '/documentation/{param*}',
            handler(req, res) {
                return res.file(basePath + '/index.html');
            }
        }
    ]);

    await server.start();
    console.log('Server is now running on %s', server.info.uri);
})();
