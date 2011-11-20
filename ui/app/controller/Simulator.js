Ext.define('Distinctivo.controller.Simulator', 
           {
               extend: 'Ext.app.Controller',
               
               views: [
                   'simulator.State',
                   'simulator.Events'
               ],
               
               stores: [
               ],
               
               models: [
               ],

               init: function() {
                   var me = this;
                   this.control({
                                });
               }
           }
);
