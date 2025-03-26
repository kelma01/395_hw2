use std::collections::HashMap;
use std::io::{self, Write};

//operatorler ve expresionlar icin tekrarli tanimlamalardansa enum kullanildi


struct Calculator {
    variables: HashMap<String, i32>,
}

impl Calculator {
    fn new() -> Calculator {
        Calculator {
            variables: HashMap::new(),
        }
    }

    fn assign(&mut self, var: String, value: i32) {
        self.variables.insert(var, value);
    }

    fn precedence(&self, op: &str) -> i32 {
        match op {
            "+" | "-" => 1,
            "*" | "/" => 2,
            _ => 0,
        }
    }

    fn infix_to_postfix(&self, expression: &str) -> Result<Vec<String>, String> {
        let mut output: Vec<String> = Vec::new();
        let mut operators: Vec<String> = Vec::new();
        let mut num = String::new();
    
        let chars: Vec<char> = expression.chars().collect();
    
        let mut i = 0;
        while i < chars.len() {
            let ch = chars[i];
    
            if ch.is_digit(10) {
                num.push(ch);
            } 
            else if ch.is_alphabetic() {
                num.push(ch);
            } 
            else {
                if !num.is_empty() {
                    if let Ok(value) = num.parse::<i32>() {
                        output.push(value.to_string());
                    } 
                    else if let Some(&value) = self.variables.get(&num) {
                        output.push(value.to_string());
                    } 
                    else {
                        return Err(format!("Error: undefined variable '{}'", num));
                    }
                    num.clear();
                }
    
                if ch == '(' {
                    operators.push(ch.to_string());
                } 
                else if ch == ')' {
                    while let Some(op) = operators.pop() {
                        if op == "(" {
                            break;
                        }
                        output.push(op);
                    }
                } 
                else if ch == '+' || ch == '-' || ch == '*' || ch == '/' {
                    while let Some(top_op) = operators.last() {
                        if self.precedence(&top_op) >= self.precedence(&ch.to_string()) {
                            output.push(operators.pop().unwrap());
                        } else {
                            break;
                        }
                    }
                    operators.push(ch.to_string());
                }
            }
    
            i += 1;
        }
    
        if !num.is_empty() {
            if let Ok(value) = num.parse::<i32>() {
                output.push(value.to_string());
            } 
            else if let Some(&value) = self.variables.get(&num) {
                output.push(value.to_string());
            } 
            else {
                return Err(format!("Error: undefined variable '{}'", num));
            }
        }
    
        while let Some(op) = operators.pop() {
            if op == "(" || op == ")" {
                return Err("Error: parentheses are not valid".to_string());
            }
            output.push(op);
        }
    
        Ok(output)
    }

    fn parse_postfix(&self, postfix: Vec<String>) -> Result<i32, String> {
        let mut stack: Vec<i32> = Vec::new();

        for token in postfix {
            if let Ok(num) = token.parse::<i32>() {
                stack.push(num);
            } 
            else {
                let right = stack.pop().ok_or("Error: missing operand")?;
                let left = stack.pop().ok_or("Error: missing operand")?;

                let result = match token.as_str() {
                    "+" => left + right,
                    "-" => left - right,
                    "*" => left * right,
                    "/" => {
                        if right == 0 {
                            return Err("Error: cannot divided by zero".to_string());
                        } 
                        else {
                            left / right
                        }
                    }
                    _ => return Err("Error: invalid operator".to_string()),
                };

                stack.push(result);
            }
        }

        stack.pop().ok_or("Error: calculation error".to_string())
    }

    fn parse_and_evaluate(&mut self, input: &str) -> Result<i32, String> {
        let input = input.trim().replace(" ", ""); 
        
        let parts: Vec<&str> = input.split("=").collect();
        if parts.len() == 2 {
            let var = parts[0].to_string();
            let value = parts[1].parse::<i32>().map_err(|_| "Error: invalid number".to_string())?;
            self.assign(var, value);
            return Ok(value);
        }

        let postfix = self.infix_to_postfix(&input)?;
        self.parse_postfix(postfix)
    }
}

fn main() {
    let mut calc = Calculator::new();

    println!("Basic Arithmetic Calculator, type `exit` to exit");

    loop {
        print!("Enter expression below:");
        io::stdout().flush().unwrap();

        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        let input = input.trim();

        if input == "exit" {
            break;
        }

        match calc.parse_and_evaluate(input) {
            Ok(result) => println!("> {}", result),
            Err(e) => println!("> {}", e),
        }
    }
}
