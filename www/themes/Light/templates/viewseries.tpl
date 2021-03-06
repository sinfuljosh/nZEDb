{if $nodata != ""}
	<h1>View TV Series</h1>
	<p>{$nodata}</p>
{else}
<h1>
{foreach $show as $s}
	{if isset($isadmin)}
		<a title="Edit Show data" href="{$smarty.const.WWW_TOP}/admin/show-edit.php?id={$s.id}&amp;from={$smarty.server.REQUEST_URI|escape:"url"}">{$s.title} </a>
	{else}
		{$s.title}
	{/if}
	{if !$s@last} / {/if}
{/foreach}

{if $catname != ''} in {$catname|escape:"htmlall"}{/if}

</h1>

<div class="tvseriesheading">
	{if $show.image != 0}<img class="shadow" alt="{$show.title} Logo" src="{$smarty.const.WWW_TOP}/covers/{$show.id}.jpg" />{/if}
	<p>
		<span class="descinitial">{$seriesdescription|escape:"htmlall"|nl2br|magicurl|truncate:"1500":" <a class=\"descmore\" href=\"#\">more...</a>"}</span>
		{if $seriesdescription|strlen > 1500}<span class="descfull">{$seriesdescription|escape:"htmlall"|nl2br|magicurl}</span>{/if}
	</p>

</div>
<b>My Shows</b>:
<span>
{if $myshows.id != ''}
&nbsp;[ <a href="{$smarty.const.WWW_TOP}/myshows/edit/{$show.id}?from={$smarty.server.REQUEST_URI|escape:"url"}" class="myshows" rel="edit" name="series{$show.id}" title="Edit">Edit</a> ]
&nbsp;[ <a href="{$smarty.const.WWW_TOP}/myshows/delete/{$show.id}?from={$smarty.server.REQUEST_URI|escape:"url"}" class="myshows" rel="remove" name="series{$show.id}" title="Remove from My Shows">Remove</a> ]
{else}
&nbsp;[ <a href="{$smarty.const.WWW_TOP}/myshows/add/{$show.id}?from={$smarty.server.REQUEST_URI|escape:"url"}" class="myshows" rel="add" name="series{$show.id}" title="Add to My Shows">Add</a> ]
{/if}

<form id="nzb_multi_operations_form" action="get">

<div class="nzb_multi_operations">
	<div style="padding-bottom:10px;" >
		{if $show.tvrage !== 0}<a target="_blank" href="{$site->dereferrer_link}http://www.tvrage.com/shows/id-{$show.tvrage}" title="View in TvRage">View in Tv Rage</a>{/if}
		<a href="{$smarty.const.WWW_TOP}/rss?rage={$show.id}{if $category != ''}&amp;t={$category}{/if}&amp;dl=1&amp;i={$userdata.id}&amp;r={$userdata.rsstoken}">Rss Feed for this Series</a>
	</div>
	<small>With Selected:</small>
	<input type="button" class="nzb_multi_operations_download" value="Download NZBs" />
	<input type="button" class="nzb_multi_operations_cart" value="Add to Cart" />
	{if $sabintegrated}<input type="button" class="nzb_multi_operations_sab" value="Send to my Queue" />{/if}
	{if isset($isadmin)}
	&nbsp;&nbsp;
	<input type="button" class="nzb_multi_operations_edit" value="Edit" />
	<input type="button" class="nzb_multi_operations_delete" value="Del" />
	{/if}
</div>

<a id="latest"></a>
<table style="width:100%;" class="data highlight icons" id="browsetable">
	{foreach $seasons as $seasonnum => $season}
		<tr>
			<td style="padding-top:15px;" colspan="10"><h2>Season {$seasonnum}</h2></td>
		</tr>
		<tr>
			<th>Ep</th>
			<th>Name</th>
			<th><input id="chkSelectAll{$seasonnum}" type="checkbox" name="{$seasonnum}" class="nzb_check_all_season" /><label for="chkSelectAll{$seasonnum}" style="display:none;">Select All</label></th>
			<th>Category</th>
			<th style="text-align:center;">Posted</th>
			<th>Size</th>
			<th>Files</th>
			<th>Stats</th>
			<th></th>
		</tr>
		{foreach $season as $episodes}
			{foreach $episodes as $result}
				<tr class="{cycle values=",alt"}" id="guid{$result.guid}">
					{if $result@total>1 && $result@index == 0}
						<td width="20" rowspan="{$result@total}" class="static">{$episodes@key}</td>
					{elseif $result@total == 1}
						<td width="20" class="static">{$episodes@key}</td>
					{/if}
					<td>
						<a title="View details" href="{$smarty.const.WWW_TOP}/details/{$result.guid}">{$result.searchname|escape:"htmlall"|replace:".":" "}</a>

						<div class="resextra">
							<div class="btns">
								{if $result.nfoid > 0}<a href="{$smarty.const.WWW_TOP}/nfo/{$result.guid}" title="View Nfo" class="modal_nfo rndbtnsml" rel="nfo">Nfo</a>{/if}
								{if $result.haspreview == 1 && $userdata.canpreview == 1}<a href="{$smarty.const.WWW_TOP}/covers/preview/{$result.guid}_thumb.jpg" name="name{$result.guid}" title="Screenshot of {$result.searchname|escape:"htmlall"}" class="modal_prev rndbtnsml" rel="preview">Preview</a>{/if}
								{if $result.firstaired != ""}<span class="rndbtnsml" title="{$result.title} Aired on {$result.firstaired|date_format}">Aired {if $result.firstaired|strtotime > $smarty.now}in future{else}{$result.firstaired|daysago}{/if}</span>{/if}
								{if $result.reid > 0}<span class="mediainfo rndbtnsml" title="{$result.guid}">Media</span>{/if}
							</div>

							{if isset($isadmin)}
							<div class="admin">
								<a class="rndbtnsml" href="{$smarty.const.WWW_TOP}/admin/release-edit.php?id={$result.id}&amp;from={$smarty.server.REQUEST_URI|escape:"url"}" title="Edit Release">Edit</a> <a class="rndbtnsml confirm_action" href="{$smarty.const.WWW_TOP}/admin/release-delete.php?id={$result.id}&amp;from={$smarty.server.REQUEST_URI|escape:"url"}" title="Delete Release">Del</a>
							</div>
							{/if}
						</div>
					</td>
					<td class="check"><input id="chk{$result.guid|substr:0:7}" type="checkbox" class="nzb_check" name="{$seasonnum}" value="{$result.guid}" /></td>
					<td class="less"><a title="This series in {$result.category_name}" href="{$smarty.const.WWW_TOP}/series/{$result.videos_id}?t={$result.categories_id}">{$result.category_name}</a></td>
					<td class="less mid" width="40" title="{$result.postdate}">{$result.postdate|timeago}</td>
					<td width="40" class="less right">{$result.size|fsize_format:"MB"}{if $result.completion > 0}<br />{if $result.completion < 100}<span class="warning">{$result.completion}%</span>{else}{$result.completion}%{/if}{/if}</td>
					<td class="less mid">
						<a title="View file list" href="{$smarty.const.WWW_TOP}/filelist/{$result.guid}">{$result.totalpart}</a>
						{if $result.rarinnerfilecount > 0}
							<div class="rarfilelist">
								<img src="{$smarty.const.WWW_TOP}/themes/shared/img/icons/magnifier.png" alt="{$result.guid}" class="tooltip" />
							</div>
						{/if}
					</td>
					<td width="40" class="less" nowrap="nowrap"><a title="View comments for {$result.searchname|escape:"htmlall"}" href="{$smarty.const.WWW_TOP}/details/{$result.guid}#comments">{$result.comments} cmt{if $result.comments != 1}s{/if}</a><br/>{$result.grabs} grab{if $result.grabs != 1}s{/if}</td>
					<td class="icons">
						<div class="icon icon_nzb"><a title="Download Nzb" href="{$smarty.const.WWW_TOP}/getnzb/{$result.guid}">&nbsp;</a></div>
						{if $sabintegrated}<div class="icon icon_sab" title="Send to my Queue"></div>{/if}
						<div class="icon icon_cart" title="Add to Cart"></div>
					</td>
				</tr>
			{/foreach}
		{/foreach}
	{/foreach}
</table>

</form>
{/if}
