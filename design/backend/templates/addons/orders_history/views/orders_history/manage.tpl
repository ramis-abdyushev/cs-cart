{capture name="mainbox"}

{$order_status_descr = $smarty.const.STATUSES_ORDER|fn_get_simple_statuses:true:true}
{$order_statuses = $smarty.const.STATUSES_ORDER|fn_get_statuses:$statuses:true:true}

<form action="{""|fn_url}" method="post" target="_self" name="manage_orders_history_form" id="manage_orders_history_form" data-ca-is-multiple-submit-allowed="true">

{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id=$smarty.request.content_id}

{$c_url=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{$rev=$smarty.request.content_id|default:"pagination_contents"}
{$page_title=__("orders_history")}
{$extra_status=$config.current_url|escape:"url"}
{$notify_vendor = fn_allowed_for("MULTIVENDOR")}
{$notify=true}
{$notify_department=true}

{include_ext file="common/icon.tpl" class="icon-`$search.sort_order_rev`" assign=c_icon}
{include_ext file="common/icon.tpl" class="icon-dummy" assign=c_dummy}

{if $orders_history}
    {capture name="orders_table"}
        <div class="table-responsive-wrapper longtap-selection">
            <table width="100%" class="table table-middle table--relative table-responsive table-manage-orders">
            <thead data-ca-bulkedit-default-object="true" data-ca-bulkedit-component="defaultObject">
            <tr>
                <th width="20%" class="left"><a class="cm-ajax" href="{"`$c_url`&sort_by=order_id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("id")}{if $search.sort_by === "order_id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=status_from&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history_old_status")}{if $search.sort_by === "status_from"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=status_to&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history_new_status")}{if $search.sort_by === "status_to"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=editor&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history_changed")}{if $search.sort_by === "editor"}{$c_icon nofilter}{/if}</a></th>
                <th width="20%" class="right"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("orders_history_date_change")}{if $search.sort_by === "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            </tr>
            </thead>
            {foreach from=$orders_history item="o"}
            <tr class="cm-longtap-target"
                data-ca-longtap-action="setCheckBox"
                data-ca-longtap-target="input.cm-item"
                data-ca-id="{$o.order_id}"
            >
                <td width="20" class="left" data-th="{__("id")}">
                    <a href="{"orders.details?order_id=`$o.order_id`"|fn_url}" class="underlined">{__("order")} <bdi>#{$o.order_id}</bdi></a>
                </td>
                <td width="20%" data-th="{__("orders_history_old_status")}">
                    {$status_from = $o.status_from}
                    {$order_status_descr.$status_from|default:$default_status_text}
                </td>
                <td width="20%" data-th="{__("orders_history_new_status")}">
                    {$status_to = $o.status_to}
                    {$order_status_descr.$status_to|default:$default_status_text}
                </td>
                <td width="20%" data-th="{__("orders_history_changed")}">
                    {if $o.user_id}<a href="{"profiles.update?user_id=`$o.user_id`"|fn_url}">{/if}{$o.lastname} {$o.firstname}{if $o.user_id}</a>{/if}
                </td>
                <td width="20%" class="nowrap right" data-th="{__("date")}">{$o.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
            </tr>
            {/foreach}
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="orders_list_form"
        object="orders"
        items=$smarty.capture.orders_table
    }
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id=$smarty.request.content_id}

</form>
{/capture}

{include file="common/mainbox.tpl"
    title=$page_title
    sidebar=$smarty.capture.sidebar
    content=$smarty.capture.mainbox
    content_id="manage_orders"
    select_storefront=true
    storefront_switcher_param_name="storefront_id"
    selected_storefront_id=$selected_storefront_id
}