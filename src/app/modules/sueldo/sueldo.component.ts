import { Component, OnDestroy, OnInit } from '@angular/core';
import { CountdownService } from '../../services/countdown.service';
import { Observable, Subscription } from 'rxjs';
import { MatButtonModule } from '@angular/material/button';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-sueldo',
  standalone: true,
  imports: [MatButtonModule, RouterLink],
  templateUrl: './sueldo.component.html',
  styleUrl: './sueldo.component.css',
})
export class SueldoComponent implements OnInit, OnDestroy {
  public days: number = 0;
  public hours: number = 0;
  public minutes: number = 0;
  public seconds: number = 0;
  public payDate: string = '';
  private subscription: Subscription = new Subscription();

  constructor(private readonly countdownService: CountdownService) {}

  ngOnInit(): void {
    this.subscription.add(
      this.countdownService.days.subscribe((days) => (this.days = days))
    );
    this.subscription.add(
      this.countdownService.hours.subscribe((hours) => (this.hours = hours))
    );
    this.subscription.add(
      this.countdownService.minutes.subscribe(
        (minutes) => (this.minutes = minutes)
      )
    );
    this.subscription.add(
      this.countdownService.seconds.subscribe(
        (seconds) => (this.seconds = seconds)
      )
    );
    this.subscription.add(
      this.countdownService.payDate.subscribe(
        (payDate) => (this.payDate = payDate)
      )
    );
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
