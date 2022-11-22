package com.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
@RestController
public class EurekaClientTesterApplication {

	@Autowired @LoadBalanced
	RestTemplate restTemplate;

	@GetMapping("/check")
	public String foo() {
		return restTemplate.getForObject("http://client/foo", String.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(EurekaClientTesterApplication.class, args);
	}
}

@Configuration
class Config {

	@Bean @LoadBalanced
	RestTemplate restTemplate() {
		return new RestTemplate();
	}
}
