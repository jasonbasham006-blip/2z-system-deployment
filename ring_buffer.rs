use std::sync::atomic::{AtomicUsize, Ordering};

#[derive(Debug, Clone, Copy)]
pub struct HoldingRegister {
    pub numerator: u128,
    pub denominator: u128,
}

impl HoldingRegister {
    pub fn new() -> Self {
        Self { numerator: 1, denominator: 1 }
    }

    pub fn accumulate(&mut self, num: u128, den: u128) {
        self.numerator = self.numerator.saturating_mul(num);
        self.denominator = self.denominator.saturating_mul(den);
    }

    pub fn evaluate_boundary(&self, integer_kernel: u128) -> f64 {
        let dec_val = (integer_kernel >> 1) as f64;
        (dec_val * self.numerator as f64) / (self.denominator as f64)
    }
}

fn main() {
    println!("--- RUST 2Z RING BUFFER ENGINE ONLINE ---");
    let mut holding_reg = HoldingRegister::new();
    holding_reg.accumulate(1, 100);
    holding_reg.accumulate(66, 1);
    
    let kernel_accumulator: u128 = 2840; // 2Z rail value
    let boundary_out = holding_reg.evaluate_boundary(kernel_accumulator);
    
    println!("2Z Kernel Integer Accumulator: {}", kernel_accumulator);
    println!("Quarantined Boundary Output: {:.4}", boundary_out);
}
