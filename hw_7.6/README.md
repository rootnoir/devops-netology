# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.

- Ответ:
  - [provider.go#L422](https://github.com/hashicorp/terraform-provider-aws/blob/77b78592c1a15c0b41d0f16f6f115696f9771731/internal/provider/provider.go#L422)
  - [provider.go#L901](https://github.com/hashicorp/terraform-provider-aws/blob/77b78592c1a15c0b41d0f16f6f115696f9771731/internal/provider/provider.go#L901)
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
      * Ответ: [queue.go#L87](https://github.com/hashicorp/terraform-provider-aws/blob/77b78592c1a15c0b41d0f16f6f115696f9771731/internal/service/sqs/queue.go#L87)
    * Какая максимальная длина имени? 
      * Ответ: 80 символов
      
      ```go
        if fifoQueue {
            re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
        } else {
            re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
        }

        if !re.MatchString(name) {
            return fmt.Errorf("invalid queue name: %s", name)
        }
      ```
      
    * Какому регулярному выражению должно подчиняться имя?
      * Ответ:
        * [queue.go#L425](https://github.com/hashicorp/terraform-provider-aws/blob/77b78592c1a15c0b41d0f16f6f115696f9771731/internal/service/sqs/queue.go#L425) - `^[a-zA-Z0-9_-]{1,75}\.fifo$`
        * [queue.go#L427](https://github.com/hashicorp/terraform-provider-aws/blob/77b78592c1a15c0b41d0f16f6f115696f9771731/internal/service/sqs/queue.go#L427) - `^[a-zA-Z0-9_-]{1,80}$`
        
    