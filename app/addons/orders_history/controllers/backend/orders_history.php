<?php

use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

if ($mode === 'manage') {
    
    $params = $_REQUEST;

    list($orders_history, $search) = fn_get_orders_history($params, Registry::get('settings.Appearance.admin_elements_per_page'));

    Tygh::$app['view']->assign('orders_history', $orders_history);
    Tygh::$app['view']->assign('search', $search);
}