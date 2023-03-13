resource "aws_appautoscaling_target" "friends_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.peer_ecs_cluster.name}/${aws_ecs_service.friends_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}

resource "aws_appautoscaling_target" "user_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.peer_ecs_cluster.name}/${aws_ecs_service.user_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}


resource "aws_appautoscaling_target" "chat_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.chat_ecs_cluster.name}/${aws_ecs_service.chat_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}



#################################
### Perfomrance based scaling ###
#################################

resource "aws_cloudwatch_metric_alarm" "friends_cpu_utilization_high" {
  alarm_name          = "app-${local.name}-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.peer_ecs_cluster.name
    ServiceName = aws_ecs_service.friends_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.friends_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "user_cpu_utilization_high" {
  alarm_name          = "app-${local.name}-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.peer_ecs_cluster.name
    ServiceName = aws_ecs_service.user_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.user_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "chat_cpu_utilization_high" {
  alarm_name          = "app-${local.name}-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.chat_ecs_cluster.name
    ServiceName = aws_ecs_service.chat_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.chat_up.arn]
}


resource "aws_cloudwatch_metric_alarm" "friends_cpu_utilization_low" {
  alarm_name          = "app-${local.name}-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.peer_ecs_cluster.name
    ServiceName = aws_ecs_service.friends_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.friends_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "user_cpu_utilization_low" {
  alarm_name          = "app-${local.name}-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.peer_ecs_cluster.name
    ServiceName = aws_ecs_service.user_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.user_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "chat_cpu_utilization_low" {
  alarm_name          = "app-${local.name}-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = aws_ecs_cluster.chat_ecs_cluster.name
    ServiceName = aws_ecs_service.chat_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.chat_down.arn]
}

resource "aws_appautoscaling_policy" "friends_up" {
  name               = "friends-scale-up"
  service_namespace  = aws_appautoscaling_target.friends_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.friends_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.friends_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "user_up" {
  name               = "friends-scale-up"
  service_namespace  = aws_appautoscaling_target.user_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.user_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.user_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "chat_up" {
  name               = "chat-app-scale-up"
  service_namespace  = aws_appautoscaling_target.chat_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.chat_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.chat_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "friends_down" {
  name               = "friends-scale-down"
  service_namespace  = aws_appautoscaling_target.friends_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.friends_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.friends_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "user_down" {
  name               = "friends-scale-down"
  service_namespace  = aws_appautoscaling_target.user_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.user_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.user_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "chat_down" {
  name               = "chat-scale-down"
  service_namespace  = aws_appautoscaling_target.chat_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.chat_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.chat_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
