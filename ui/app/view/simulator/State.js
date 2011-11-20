Ext.define('Distinctivo.view.simulator.State', {
               extend: 'Ext.grid.Panel',
               alias : 'widget.state',
               title: 'State',
               layout: 'fit',
               store: 'SystemState',
               columns: [
                   {header: 'Object',  dataIndex: 'object',  flex: 1},
                   {header: 'Description', dataIndex: 'description', flex: 1}
               ],
               tbar: [{xtype: 'button',
                      text: 'Refresh',
                      bubbleEvents: ['refresh'],
                      handler: function() {
                          this.fireEvent("refresh");
                      }
                     }],
               listeners: {
                   refresh: function() {
                       this.store.load();
                   }
               }
           });
               

