{*
 * Shop System Plugins - Terms of Use
 *
 * The plugins offered are provided free of charge by Wirecard Central Eastern Europe GmbH
 * (abbreviated to Wirecard CEE) and are explicitly not part of the Wirecard CEE range of
 * products and services.
 *
 * They have been tested and approved for full functionality in the standard configuration
 * (status on delivery) of the corresponding shop system. They are under General Public
 * License Version 2 (GPLv2) and can be used, developed and passed on to third parties under
 * the same terms.
 *
 * However, Wirecard CEE does not provide any guarantee or accept any liability for any errors
 * occurring when used in an enhanced, customized shop system configuration.
 *
 * Operation in an enhanced, customized configuration is at your own risk and requires a
 * comprehensive test phase by the user of the plugin.
 *
 * Customers use the plugins at their own risk. Wirecard CEE does not guarantee their full
 * functionality neither does Wirecard CEE assume liability for any disadvantages related to
 * the use of the plugins. Additionally, Wirecard CEE does not guarantee the full functionality
 * for customized shop systems or installed plugins of other vendors of plugins within the same
 * shop system.
 *
 * Customers are responsible for testing the plugin's functionality before starting productive
 * operation.
 *
 * By installing the plugin into the shop system the customer agrees to these terms of use.
 * Please do not use the plugin if you do not agree to these terms of use!
 *}

<div class="wirecardcheckoutseamless-wrapper">
    <a href="https://www.wirecard.at/" target="_blank" title="www.wirecard.at"><img
                class="wirecardcheckoutseamless-logo" src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/wirecard-logo.png" alt="Wirecard CEE"
                border="0"/>
    </a><br/>
    <p class="wirecardcheckoutseamless-intro">{l s='Wirecard - Your Full Service Payment Provider - Comprehensive solutions from one single source' mod='wirecardceecheckoutseamless'}</p>
    {l s='Wirecard is one of the world´s leading providers of outsourcing and white label solutions for electronic payment transactions.' mod='wirecardceecheckoutseamless'}
    <br/><br/>
    {l s='As independent provider of payment solutions, we accompany our customers along the entire business development. Our payment solutions are perfectly tailored to suit e-Commerce requirements and have made us Austria´s leading payment service provider. Customization, competence, and commitment.' mod='wirecardceecheckoutseamless'}<br/>
    <br/>
    {if $is_core}
    <p><a href="https://checkoutportal.com/{$country|escape:'htmlall'}/{$language|escape:'htmlall'}/prestashop/" target="_blank">
            {l s='Registration for new clients' mod='wirecardceecheckoutseamless'}
        </a></p>
    {/if}
    <p><a href="https://guides.wirecard.at/doku.php/plugins_general" target="_blank">{l s='General information regarding Wirecard Shop Plugins' mod='wirecardceecheckoutseamless'}</a></p>
    <div style="clear:both;"></div>
    <div class="btn-group">
        <a class="btn btn-default" id="doWcsConfigTest" href="#">
            <i class="icon-check"></i>
            {l s='Test configuration' mod='wirecardceecheckoutseamless'}
        </a>
        <a class="btn btn-default" id="doWcsContactSupport" href="{$link->getAdminLink('AdminWirecardCEECheckoutSeamlessSupport')|escape:'html':'UTF-8'}">
            <i class="icon-question"></i>
            {l s='Contact support' mod='wirecardceecheckoutseamless'}
        </a>
        {if $backendEnabled}
        <a class="btn btn-default" id="doWcsBackendTransactions" href="{$link->getAdminLink('AdminWirecardCEECheckoutSeamlessBackend')|escape:'html':'UTF-8'}">
            <i class=e"icon-mony"></i>
            {l s='Transactions' mod='wirecardceecheckoutseamless'}
        </a>
        <a class="btn btn-default" id="doWcsBackendFundTransfer"
           href="{$link->getAdminLink('AdminWirecardCEECheckoutSeamlessFundTransfer')|escape:'html':'UTF-8'}">
            <i class="icon-exchange"></i>
            {l s='Fund transfer' mod='wirecardceecheckoutseamless'}
        </a>
        {/if}
    </div>
    <div style="clear:both;"></div>
    <p></p>
</div>

<script type="text/javascript">
    $(function () {
        $('#doWcsConfigTest').on('click', function() {
            $.ajax({
                type: 'POST',
                {** this url doesn't work when escaped *}
                url: '{$ajax_configtest_url}',
                dataType: 'json',
                data: {
                    controller: 'AdminModules',
                    action: 'ajaxTestConfig',
                    ajax: true
                },
                success: function (jsonData) {
                    if (jsonData) {
                        $.fancybox({
                            fitToView: true,
                            content: '<div><fieldset><legend>{l s='Test result' mod='wirecardceecheckoutseamless'}</legend>' +
                                '<label>{l s='Status' mod='wirecardceecheckoutseamless'}:</label>' +
                                '<div class="margin-form" style="text-align:left;">' + jsonData.status + '</div><br />' +
                                '<label>{l s='Message' mod='wirecardceecheckoutseamless'}:</label>' +
                                '<div class="margin-form" style="text-align:left;">' + jsonData.message + '</div></fieldset></div>'
                        });
                    }
                }
            });
        });
    });
    {if $backendEnabled}
    $(document).ready(function(){
        var inp = $("#WCS_BASICDATA_BACKENDPW");
        var customerIdInp = $("#WCS_BASICDATA_CUSTOMER_ID");
        var modeSelect = $("#WCS_BASICDATA_CONFIGMODE");

        enableDisableBackendOperations(inp,true);
        correctCustomerId(customerIdInp);
        modeSelectED(modeSelect);
        inp.on("keyup change paste",function(){
            enableDisableBackendOperations($(this));
        });
        customerIdInp.on("keyup change paste", function(){
            $(this).closest(".input-group").toggleClass("has-error", !correctCustomerId($(this)));
        });
        modeSelect.on('blur change',function(){
            modeSelectED($(this));
        });

        $("#configuration_form").submit(function(e){
            $('#WCS_BASICDATA_CUSTOMER_ID, #WCS_BASICDATA_SHOP_ID, #WCS_BASICDATA_SECRET').prop('disabled',false);
        });

        function modeSelectED(e){
            var state = e.val()=='production';
            $('#WCS_BASICDATA_CUSTOMER_ID, #WCS_BASICDATA_SHOP_ID, #WCS_BASICDATA_SECRET').prop('disabled',!state);
        }

        function correctCustomerId(inp){
            return /^D2[0-8]\d{ldelim}4{rdelim}|9[5-9]\d{ldelim}3{rdelim}$/.test(inp.val());
        }

        function enableDisableBackendOperations(inp,init=false){
            if(inp.val().length==0){
                if(init)
                    $("#doWcsBackendTransactions,#doWcsBackendFundTransfer").remove();
                else
                    $("#doWcsBackendTransactions,#doWcsBackendFundTransfer").addClass("disabled");
            }
            else
                $("#doWcsBackendTransactions,#doWcsBackendFundTransfer").removeClass("disabled");
        }
    });
    {/if}
</script>