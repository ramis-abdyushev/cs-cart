<?php

use Tygh\Navigation\LastView;

defined('BOOTSTRAP') or die('Access denied');

function fn_orders_history_change_order_status($status_to, $status_from, $order_info, $force_notification, $order_statuses, $place_order)
{
    if (!empty($_SESSION['auth']['user_id'])) {
        $user_id = $_SESSION['auth']['user_id'];
    } else {
        $user_id = 0;
    }

    $row = [
        'order_id' => $order_info['order_id'],
        'user_id' => $user_id,
        'timestamp' => TIME,
        'status_from' => $status_from,
        'status_to' => $status_to
    ];

    $log_id = db_query("INSERT INTO ?:orders_history_logs ?e", $row);

    return true;
}

function fn_get_orders_history($params, $items_per_page = 0) {

    $params = LastView::instance()->update('orders_history', $params);

    $default_params = [
        'page'           => 1,
        'items_per_page' => $items_per_page
    ];

    $params = array_merge($default_params, $params);

    $fields = [
        '?:orders_history_logs.*',
        '?:users.firstname',
        '?:users.lastname'
    ];

    $sortings = [
        'order_id' => '?:orders_history_logs.order_id',
        'status_from' => '?:orders_history_logs.status_from',
        'status_to' => '?:orders_history_logs.status_to',
        'editor' => ['?:users.lastname', '?:users.firstname'],
        'date' => ['?:orders_history_logs.timestamp', '?:orders_history_logs.order_id']
    ];

    $sorting = db_sort($params, $sortings, 'editor', 'desc');

    $join = "LEFT JOIN ?:users USING(user_id)";

    $limit = '';
    
    if (!empty($params['items_per_page'])) {
    $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:orders_history_logs");
        $limit = db_paginate($params['page'], $params['items_per_page']);
    }

    $data = db_get_array("SELECT " . join(', ', $fields) . " FROM ?:orders_history_logs ?p WHERE 1 $sorting $limit", $join);

    LastView::instance()->processResults('orders_history_logs', $data, $params);

    return array($data, $params);
}