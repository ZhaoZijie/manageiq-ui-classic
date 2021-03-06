module ApplicationHelper::PageLayouts
  def layout_uses_listnav?
    return false if @in_a_form
    return false if %w(
      about
      all_tasks
      chargeback
      configuration
      container_dashboard
      container_topology
      ems_infra_dashboard
      infra_topology
      middleware_topology
      network_topology
      cloud_topology
      diagnostics
      exception
      miq_ae_automate_button
      miq_ae_customization
      miq_ae_export
      miq_ae_logs
      miq_ae_tools
      miq_policy
      miq_policy_export
      miq_policy_logs
      monitor_alerts_overview
      monitor_alerts_list
      monitor_alerts_most_recent
      my_tasks
      ops
      physical_infra_topology
      pxe
      report
      rss
      server_build
      storage
      storage_pod
    ).include?(@layout)

    return false if %w(
      ad_hoc_metrics
      consumption
      dashboard
      dialog_provision
      topology
    ).include?(@showtype)

    return false if dashboard_no_listnav?

    return false if @layout.starts_with?("miq_request")

    return false if controller.action_name.end_with?("tagging_edit")

    true
  end

  def layout_uses_paging?
    # listnav always implies paging, this only handles the non-listnav case
    %w(
      all_tasks
      miq_request_ae
      miq_request_host
      miq_request_service
      miq_request_vm
      my_tasks
    ).include?(@layout) && params[:action] != 'show'
  end

  def layout_uses_tabs?
    if (["timeline"].include?(@layout) && ! @in_a_form) ||
       ["login", "authenticate", "auth_error"].include?(controller.action_name) ||
       @layout == "exception" ||
       (@layout == 'vm' && controller.action_name == 'edit') ||
       (@layout == "report" && ["new", "create", "edit", "copy", "update", "explorer"].include?(controller.action_name))
      return false
    elsif %w(container_dashboard dashboard ems_infra_dashboard).include?(@layout) ||
          (%w(dashboard).include?(@showtype) && @lastaction.ends_with?("_dashboard")) ||
          %w(topology).include?(@showtype)
      # Dashboard tabs are located in taskbar because they are otherwise hidden behind the taskbar regardless of z-index
      return false
    elsif @layout == "monitor_alerts_overview" ||
          @layout == "monitor_alerts_list" ||
          @layout == "monitor_alerts_most_recent"
      return false
    end
    true
  end

  def layout_uses_breadcrumbs?
    !["dashboard",
      "exception",
      "support",
      "configuration",
      "rss"].include?(@layout)
  end

  def dashboard_no_listnav?
    @layout == "dashboard" && %w(
      auth_error
      change_tab
      show
    ).include?(controller.action_name)
  end
end
