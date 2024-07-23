import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class CountdownService {
  public days: BehaviorSubject<number> = new BehaviorSubject<number>(0);
  public hours: BehaviorSubject<number> = new BehaviorSubject<number>(0);
  public minutes: BehaviorSubject<number> = new BehaviorSubject<number>(0);
  public seconds: BehaviorSubject<number> = new BehaviorSubject<number>(0);
  public payDate: BehaviorSubject<string> = new BehaviorSubject<string>('');

  public aguinaldoDays: BehaviorSubject<number> = new BehaviorSubject<number>(
    0
  );
  public aguinaldoHours: BehaviorSubject<number> = new BehaviorSubject<number>(
    0
  );
  public aguinaldoMinutes: BehaviorSubject<number> =
    new BehaviorSubject<number>(0);
  public aguinaldoSeconds: BehaviorSubject<number> =
    new BehaviorSubject<number>(0);
  public aguinaldoPayDate: BehaviorSubject<string> =
    new BehaviorSubject<string>('');

  constructor() {
    this.getPayDate();
    this.getAguinaldoPayDate();
    setInterval(() => {
      this.calculatePayDate();
      this.calculateAguinaldoPayDate();
    }, 1000);
  }

  private calculatePayDate(): void {
    this.calculateDays();
    this.calculateHours();
    this.calculateMinutes();
    this.calculateSeconds();
  }

  private calculateDays(): void {
    const now = new Date();
    const payDate = new Date(this.payDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.days.next(Math.floor(diff / (1000 * 60 * 60 * 24)));
  }

  private calculateHours(): void {
    const now = new Date();
    const payDate = new Date(this.payDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.hours.next(
      Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    );
  }

  private calculateMinutes(): void {
    const now = new Date();
    const payDate = new Date(this.payDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.minutes.next(Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)));
  }

  private calculateSeconds(): void {
    const now = new Date();
    const payDate = new Date(this.payDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.seconds.next(Math.floor((diff % (1000 * 60)) / 1000));
  }

  private getPayDate(): void {
    const date = new Date();
    const lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
    const day = lastDay.getDay();
    const lastHour = new Date(
      lastDay.getFullYear(),
      lastDay.getMonth(),
      lastDay.getDate(),
      21,
      0,
      0
    );
    if (day === 6) {
      lastHour.setDate(lastHour.getDate() - 1);
    } else if (day === 0) {
      lastHour.setDate(lastHour.getDate() - 2);
    }
    this.payDate.next(lastHour.toISOString());
  }

  private calculateAguinaldoPayDate(): void {
    this.calculateAguinaldoDays();
    this.calculateAguinaldoHours();
    this.calculateAguinaldoMinutes();
    this.calculateAguinaldoSeconds();
  }

  private calculateAguinaldoDays(): void {
    const now = new Date();
    const payDate = new Date(this.aguinaldoPayDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.aguinaldoDays.next(Math.floor(diff / (1000 * 60 * 60 * 24)));
  }

  private calculateAguinaldoHours(): void {
    const now = new Date();
    const payDate = new Date(this.aguinaldoPayDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.aguinaldoHours.next(
      Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    );
  }

  private calculateAguinaldoMinutes(): void {
    const now = new Date();
    const payDate = new Date(this.aguinaldoPayDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.aguinaldoMinutes.next(
      Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
    );
  }

  private calculateAguinaldoSeconds(): void {
    const now = new Date();
    const payDate = new Date(this.aguinaldoPayDate.value);
    const diff = payDate.getTime() - now.getTime();
    this.aguinaldoSeconds.next(Math.floor((diff % (1000 * 60)) / 1000));
  }

  public getAguinaldoPayDate(): void {
    this.aguinaldoPayDate.next('2024-12-16T10:00:00.000Z');
  }
}
