Ext.onReady(function(){
                Ext.Loader.setConfig({ enabled: true });
                Ext.application(
                    {
                        name: 'Distinctivo',
                        
                        appFolder: 'app',
                        
                        controllers: [
                            'Simulator'
                        ],
                        
                        launch: function() {
                            Ext.create('Ext.container.Viewport', {
                                           layout: 'border',
                                           items: [
                                               {
                                                   height: 80,
                                                   region: 'north',
                                                   border: false,
                                                   xtype: 'panel',
                                                   html: '<img src="http://unbouncepages-com.s3.amazonaws.com/www.distinctivo.com/distinctivo-yellow2.original_4rrk173nwf64hudc.png" height="65px"/>'
                                               },
                                               {
                                                   region: 'center',
                                                   border: false,
                                                   xtype: 'state'
                                               },
                                               {
                                                   height: '35%',
                                                   xtype: 'events',
                                                   region: 'south',
                                                   collapsible: true,
                                                   border: true
                                               }
                                           ]
                                       });
                        }}
                );
});
