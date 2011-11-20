Ext.define('Distinctivo.store.SystemState', {
    extend: 'Ext.data.Store',
    model: 'Distinctivo.model.Production',
    autoLoad: true,

    proxy: {
        type: 'ajax',
        url: '/state',
        reader: {
            type: 'json',
            successProperty: 'success'
        }
    }
});