terraform{
    required_providers{
        local = {
            source = "hashicorp/local"
            version = "2.4"
        }
    }
}

resource "local_file" "hello" {
    content = "hello"
    filename = "${path.module}/hello.txt"
}

output "filename" {
    value = local_file.hello.filename
}

output "fileid" {
    value = local_file.hello.id
}