import { Component, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { CountdownService } from '../../services/countdown.service';
import { MatButtonModule } from '@angular/material/button';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-aguinaldo',
  standalone: true,
  imports: [MatButtonModule, RouterLink],
  templateUrl: './aguinaldo.component.html',
  styleUrl: './aguinaldo.component.css',
})
export class AguinaldoComponent implements OnInit, OnDestroy {
  public days: number = 0;
  public hours: number = 0;
  public minutes: number = 0;
  public seconds: number = 0;
  public payDate: string = '';
  private subscription: Subscription = new Subscription();

  constructor(private readonly countdownService: CountdownService) {}

  ngOnInit(): void {
    this.subscription.add(
      this.countdownService.aguinaldoDays.subscribe(
        (days) => (this.days = days)
      )
    );
    this.subscription.add(
      this.countdownService.aguinaldoHours.subscribe(
        (hours) => (this.hours = hours)
      )
    );
    this.subscription.add(
      this.countdownService.aguinaldoMinutes.subscribe(
        (minutes) => (this.minutes = minutes)
      )
    );
    this.subscription.add(
      this.countdownService.aguinaldoSeconds.subscribe(
        (seconds) => (this.seconds = seconds)
      )
    );
    // this.subscription.add(
    //   this.countdownService..subscribe(
    //     (payDate) => (this.payDate = payDate)
    //   )
    // );
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
