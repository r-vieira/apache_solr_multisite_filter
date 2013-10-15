<?php

/**
 * Restrict the SOLR search results to the current site. 
 * See: https://drupal.org/node/698042
 */
function amps_apache_solr_site_filter_apachesolr_query_alter($query){
  if (variable_get('apache_solr_site_filter', FALSE)) {
    watchdog(__FUNCTION__, "filtering results");
    $query->addFilter('hash', apachesolr_site_hash());
  }
}


/**
 * Implements hook_help()
 */
function amps_apache_solr_site_filter_help($path, $arg){
  switch($path){
  case 'admin/help#apache_solr_site_filter':
    return '<p>' . t("Restricts the SOLR results to the current site") . '</p>';
      break;
  }
}

/**
 * Implements hook_menu()
 */
function amps_apache_solr_site_filter_menu(){
  $items = array();

  // configure URL
  $url = "admin/config/search/apachesolr/multisite";
  $items[$url] = array(
    'title' => 'Multisite',
    'description' => t('ONLY show SOLR results for the current site.'),
    'page callback' => 'drupal_get_form',
    'page arguments' => array('amps_apache_solr_site_filter_form'),
    'access arguments' => array('access administration pages'),
    'type' => MENU_LOCAL_TASK,
  );

  return $items;
}

/**
 * Page callback: Apache SOLR Site Filter
 */
function amps_apache_solr_site_filter_form($form, &$form_state){
  $form['apache_solr_site_filter'] = array(
    '#type' => 'checkbox',
    '#size' => 2,
    '#title' => t('ONLY show SOLR results for the current site.'),
    '#default_value' => variable_get('apache_solr_site_filter', FALSE),
    '#description' => t('Restricts the APACHE SOLR results to the current site only'),
    '#required' => FALSE,
  );
  return system_settings_form($form);
}

/**
 * Implements hook_validate()
 */
function amps_apache_solr_site_filter_validate($form, &$form_state){

  $restrict = $form['values']['apache_solr_site_filter'];
  form_set_message("Successfully saved!");
  variable_set('apache_solr_site_filter', $restrict);
  $v = ($restrict) ? 1 : 0;
  form_set_message("Successfully saved! [$v]");
}


