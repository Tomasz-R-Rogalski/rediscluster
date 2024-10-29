# Private subnets

resource "aws_subnet" "private-eu-central-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.0.0/19"
  availability_zone = "eu-central-1a"

  tags = {
    Name                              = "private-eu-central-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/redis-cluster"      = "owned"
  }
}

resource "aws_subnet" "private-eu-central-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.32.0/19"
  availability_zone = "eu-central-1b"

  tags = {
    Name                              = "private-eu-central-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/redis-cluster"      = "owned"
  }
}

# Public subnets

resource "aws_subnet" "public-eu-central-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-eu-central-1a"
    "kubernetes.io/role/elb"     = "1" 
    "kubernetes.io/cluster/redis-cluster" = "owned"
  }
}

resource "aws_subnet" "public-eu-central-1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "public-eu-central-1b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/redis-cluster" = "owned"
  }
}
