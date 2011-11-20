Ext.define('Distinctivo.controller.Simulator', 
           {
               extend: 'Ext.app.Controller',
               
               views: [
                   'simulator.State',
                   'simulator.Events'
               ],
               
               stores: [
                   'SystemState'
               ],
               
               models: [
                   'Production'
               ],

               init: function() {
                   var me = this;
                   this.control({
                                });
               }
           }
);
