# R53 ##################################################################################################################

resource "aws_route53_record" "alb-record" {
  name    = "*.${var.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.domain.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_alb.infra.dns_name
    zone_id                = aws_alb.infra.zone_id
  }
}