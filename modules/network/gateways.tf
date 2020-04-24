resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.cluster-name}-internet-gateway"
  }
}

resource "aws_eip" "nat_gateway" {
  count = var.subnet_count
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count = var.subnet_count
  allocation_id = aws_eip.nat_gateway.*.id[count.index]
  subnet_id = aws_subnet.gateway.*.id[count.index]
  tags = {
    Name = "${var.cluster-name}-nat-gateway"
  }
  depends_on = [aws_internet_gateway.main]
}