resource "aws_lb_target_group_attachment" "flask_api_tg_attach" {
  count            = length(data.aws_instances.launched_by_asg.ids)
  target_group_arn = aws_lb_target_group.flask_api_tg.id
  target_id        = data.aws_instances.launched_by_asg.ids[count.index]
  depends_on       = [data.aws_instances.launched_by_asg]
}
