data "aws_availability_zones" "available" {}

resource "aws_subnet" "gateway" {
  count = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.1${count.index}.0/24"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.cluster-name}-gateway"
  }
}

resource "aws_subnet" "application" {
  count = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.2${count.index}.0/24"
  vpc_id            = aws_vpc.main.id
  tags = map(
  "Name", "${var.cluster-name}-application",
  "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}