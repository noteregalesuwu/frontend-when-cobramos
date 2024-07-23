import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AguinaldoComponent } from './aguinaldo.component';

describe('AguinaldoComponent', () => {
  let component: AguinaldoComponent;
  let fixture: ComponentFixture<AguinaldoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AguinaldoComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AguinaldoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
