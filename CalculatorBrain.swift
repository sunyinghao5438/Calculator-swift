//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by yinghao Sun on 25/06/2015.
//  Copyright © 2015 yinghao Sun. All rights reserved.
//

import Foundation
class CalculatorBrain{
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        
        var description: String{//read only
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let symbol, _):
                    return symbol
                case . UnaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]()//栈
    
    private var knowOps = [String :Op]()//字典
    
    init(){
        func learnOp(op: Op){
            knowOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        knowOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knowOps["+"] = Op.BinaryOperation("+", +)
        knowOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knowOps["√"] = Op.UnaryOperation("√", sqrt)//因为知道得到是一个double 所以没有必要用$0之类
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        //recursion 递归
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()// ops 是read only
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)//这里的类型是Tuple
                if let operand = operandEvaluation.result {
                    return (operation(operand),operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)//失败的时候返回
    }
    
    func evaluate() -> Double? {//有时候 用户直接按一个加号，没有数字给他加 要返回nil
        //recursion 递归
        let (result, remainder) = evaluate(opStack)
        print("\(opStack)=\(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }//字典返回是 nil 有可能找不到
        return evaluate()
    }
}