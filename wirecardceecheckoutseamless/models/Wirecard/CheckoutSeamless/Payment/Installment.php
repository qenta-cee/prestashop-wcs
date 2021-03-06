<?php
/**
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
 *
 * @author    WirecardCEE
 * @copyright WirecardCEE
 * @license   GPLv2
 */

class WirecardCheckoutSeamlessPaymentInstallment extends WirecardCheckoutSeamlessPayment
{
    protected $paymentMethod = \WirecardCEE_Stdlib_PaymentTypeAbstract::INSTALLMENT;

    protected $forceSendAdditionalData = true;

    /**
     * whether payment method is available on checkoutpage
     * @param Cart $cart
     *
     * @return bool
     */
    public function isAvailable($cart)
    {
        if (!parent::isAvailable($cart)) {
            return false;
        }

        if ($this->getProvider() == 'payolution') {
            return $this->isAvailablePayolution($cart);
        } elseif ($this->getProvider() == 'ratepay') {
            return $this->isAvailableRatePay($cart);
        } elseif ($this->getProvider() == 'wirecard') {
            return $this->isAvailableWirecard($cart);
        }

        return false;
    }

    /**
     * autodeposit must not be used for Invoice and Installment to prevent the sending of an invoice or a
     * first installment to the consumer before he got the ordered product.
     * @return bool
     */
    protected function getAutoDeposit()
    {
        return false;
    }

    /**
     * allowed currencies for this payment method
     * @return array
     */
    protected function getAllowedCurrencies()
    {
        $val = $this->getConfigValue('installment_currencies');
        if (!Tools::strlen($val)) {
            return array();
        }

        $currencies = Tools::jsonDecode($val);
        if (!is_array($currencies)) {
            return array();
        }

        return $currencies;
    }

    /**
     * allowed shipping countries for this payment method
     * @return array
     */
    protected function getAllowedBillingCountries()
    {
        $val = $this->getConfigValue('installment_billing_countries');
        if (!Tools::strlen($val)) {
            return array();
        }

        $currencies = Tools::jsonDecode($val);
        if (!is_array($currencies)) {
            return array();
        }

        return $currencies;
    }

    /**
     * allowed shipping countries for this payment method
     * @return array
     */
    protected function getAllowedShippingCountries()
    {
        $val = $this->getConfigValue('installment_shipping_countries');
        if (!Tools::strlen($val)) {
            return array();
        }

        $currencies = Tools::jsonDecode($val);
        if (!is_array($currencies)) {
            return array();
        }

        return $currencies;
    }

    /**
     * whether sending of basket is forced
     * @return bool
     */
    public function forceSendingBasket()
    {
        return $this->getProvider() == 'ratepay';
    }

    /**
     * allowed billing shipping countries for this payment method
     * @return bool
     */
    protected function getBillingShippingAddressSame()
    {
        return (bool)$this->getConfigValue('installment_billingshipping_same');
    }

    /**
     * min amount limit for this payment method
     * @return int
     */
    protected function getMinAmount()
    {
        return (int)$this->getConfigValue('installment_amount_min');
    }

    /**
     * max amount limit for this payment method
     * @return int
     */
    protected function getMaxAmount()
    {
        return (int)$this->getConfigValue('installment_amount_max');
    }

    /**
     * min basket size limit for this payment method
     * @return int
     */
    protected function getMinBasketSize()
    {
        return (int)$this->getConfigValue('installment_basketsize_min');
    }

    /**
     * max basket size limit for this payment method
     * @return int
     */
    protected function getMaxBasketSize()
    {
        return (int)$this->getConfigValue('installment_basketsize_max');
    }

    /**
     * return provider
     *
     * @return string
     */
    public function getProvider()
    {
        return $this->getConfigValue('installment_provider');
    }

    /**
     * return payolution merchant id
     *
     * @return string
     */
    public function getPayolutionMid()
    {
        return $this->getConfigValue('payolution_mid');
    }

    /**
     * whether consent must be acknowledged
     *
     * @return bool
     */
    public function hasConsent()
    {
        return $this->getProvider() == 'payolution' && Configuration::get('WCS_OPTIONS_PAYOLUTION_TERMS') == true;
    }

    /**
     * return min age
     *
     * @return int
     */
    public function getMinAge()
    {
        if ($this->getProvider() == 'payolution') {
            return 18;
        }

        return (int)$this->getConfigValue('installment_min_age');
    }

    /**
     * Invoice is B2B
     *
     * @return bool
     */
    public function isB2B()
    {
        return false;
    }
}
